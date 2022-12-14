using Newtonsoft.Json.Linq;
using System;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;

namespace Auvenir.Libraries.Common.Helpers
{
    public static class ObjectExtension
    {
        public static string GetPropertyValue(this Object obj, string name)
        {
            if (obj == null)
            {
                return string.Empty;
            }

            var result = string.Empty;
            name = name ?? string.Empty;

            Type t = obj.GetType();
            if (obj.GetType() == typeof(JObject))
            {
                var jobject = JObject.FromObject(obj);
                result = jobject[name]?.ToString();
            }
            else
            {
                PropertyInfo[] props = t.GetProperties();
                foreach (var prop in props)
                {
                    if (name.Equals(prop.Name.ToLower(), StringComparison.OrdinalIgnoreCase))
                    {
                        result = prop.GetValue(obj)?.ToString();
                        break;
                    }
                }
            }

            return result;
        }

        public static void SetPropertyValue(this Object obj, string name, object value)
        {
            if (obj == null) return;

            name = name ?? string.Empty;
            var type = obj.GetType();
            var prop = type.GetProperty(name);
            if (prop != null)
            {
                prop.SetValue(obj, value, null);
            }
        }

        public static object GetPropertyObject(this object obj, string name)
        {
            if (obj == null || String.IsNullOrEmpty(name))
            {
                return null;
            }

            Type t = obj.GetType();
            if (obj.GetType() == typeof(JObject))
            {
                var jobject = JObject.FromObject(obj);
                return jobject[name];
            }
            else
            {
                PropertyInfo[] props = t.GetProperties();
                foreach (var prop in props)
                {
                    if (name.Equals(prop.Name.ToLower(), StringComparison.OrdinalIgnoreCase))
                    {
                        return prop.GetValue(obj);
                    }
                }
            }

            return null;
        }

        public static PropertyInfo[] GetPropertyInfos(dynamic dynamicObject)
        {
            Type type = dynamicObject.GetType();
            return type.GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.IgnoreCase);
        }

        public static bool IsAnyNullOrEmpty(this object obj)
        {
            if (ReferenceEquals(obj, null))
                return true;

            return obj.GetType().GetProperties()
                .Any(x => IsNullOrEmpty(x.GetValue(obj)));
        }

        private static bool IsNullOrEmpty(object value)
        {
            if (ReferenceEquals(value, null))
                return true;

            if (value is string && String.IsNullOrEmpty((string)value))
                return true;

            if (value is Guid)
                return ((Guid)value) == Guid.Empty;

            var type = value.GetType();
            return type.IsValueType
                && Equals(value, Activator.CreateInstance(type));
        }

        /// <summary>
        /// Get property name from it's expression
        /// </summary>
        /// <typeparam name="T">Entity type</typeparam>
        /// <param name="property">Property expression</param>
        /// <returns>Property name string</returns>
        public static string GetPropertyName<T>(this Expression<Func<T, object>> property)
        {
            try
            {
                var lambda = (LambdaExpression)property;
                MemberExpression memberExpression;

                if (lambda.Body is UnaryExpression)
                {
                    UnaryExpression unaryExpression = (UnaryExpression)lambda.Body;
                    memberExpression = (MemberExpression)unaryExpression.Operand;
                }
                else
                {
                    memberExpression = (MemberExpression)lambda.Body;
                }

                return memberExpression.Member.Name;
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }
    }
}