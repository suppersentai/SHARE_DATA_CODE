using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;

namespace Auvenir.Common.EngagementCreation.Utility.Helper
{
    public static class UtilityHelper
    {
        public static string ToQueryString(this object obj)
        {
            return string.Join("&", obj.GetType()
                                      .GetProperties()
                                      .Select(p => $"{Uri.EscapeDataString(p.Name)}={Uri.EscapeDataString((p.GetValue(obj) ?? string.Empty).ToString())}"));
        }

        /// <summary>
        /// Reads the json.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="path">The path.</param>
        /// <returns></returns>
        public static T ReadJsonFromFile<T>(string path)
        {
            T objResult;
            try
            {
                using (StreamReader r = new StreamReader(path))
                {
                    string json = r.ReadToEnd();
                    objResult = JsonConvert.DeserializeObject<T>(json);
                }
                return objResult;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static TTarget MapTo<TSource, TTarget>(this TSource aSource, TTarget aTarget)
        {
            const BindingFlags flags = BindingFlags.Public |
                                     BindingFlags.Instance | BindingFlags.NonPublic;

            /*TODO: find fields*/
            var srcFields = (from PropertyInfo aProp in typeof(TSource).GetProperties(flags)
                             where aProp.CanRead     //check if prop is readable
                             select new
                             {
                                 Name = aProp.Name,
                                 Type = Nullable.GetUnderlyingType(aProp.PropertyType) ??
                                                                        aProp.PropertyType
                             }).ToList();
            var trgFields = (from PropertyInfo aProp in aTarget.GetType().GetProperties(flags)
                             where aProp.CanWrite   //check if prop is writeable
                             select new
                             {
                                 Name = aProp.Name,
                                 Type = Nullable.GetUnderlyingType(aProp.PropertyType) ??
                                                                     aProp.PropertyType
                             }).ToList();

            /*TODO: common fields where name and type same*/
            var commonFields = srcFields.Intersect(trgFields).ToList();

            /*assign values*/
            foreach (var aField in commonFields)
            {
                var value = aSource.GetType().GetProperty(aField.Name, flags).GetValue(aSource, null);
                PropertyInfo propertyInfos = aTarget.GetType().GetProperty(aField.Name, flags);
                propertyInfos.SetValue(aTarget, value, null);
            }
            return aTarget;
        }

        public static T Clone<T>(this T source) where T : new()
        {
            return source.CreateMapped<T, T>();
        }

        /*returns new object with mapping*/
        public static TTarget CreateMapped<TSource, TTarget>(this TSource aSource) where TTarget : new()
        {
            return aSource.MapTo(new TTarget());
        }

        public static T ToEnum<T>(this string value)
        {
            return (T)Enum.Parse(typeof(T), value, true);
        }

        public static T ToEnum<T>(this string value, T defaultValue) where T : struct
        {
            if (string.IsNullOrEmpty(value))
            {
                return defaultValue;
            }

            return Enum.TryParse<T>(value, true, out T result) ? result : defaultValue;
        }

        public static List<T> DeepClone<T>(this List<T> listObj)
        {
            var result = new List<T>();
            foreach (var item in listObj)
            {
                result.Add((T)CloneObject(item));
            }
            return result;
        }

        public static T DeepClone<T>(this T obj)
        {
            return (T)CloneObject(obj);
        }

        private static object CloneObject(object objSource)
        {
            var type = objSource.GetType();
            var target = Activator.CreateInstance(type);
            var propInfo = type.GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            foreach (PropertyInfo prop in propInfo)
            {
                if (prop.CanWrite && prop.CanRead)
                {
                    if (prop.PropertyType.IsValueType || prop.PropertyType.IsEnum || prop.PropertyType.Equals(typeof(System.String)))
                    {
                        prop.SetValue(target, prop.GetValue(objSource, null), null);
                    }
                    else
                    {
                        object objPropertyValue = prop.GetValue(objSource, null);
                        if (objPropertyValue == null)
                        {
                            prop.SetValue(target, null, null);
                        }
                    }
                }
            }
            return target;
        }
    }
}
