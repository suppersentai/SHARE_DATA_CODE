using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using System.IO;
using System.Text.RegularExpressions;
using System.IdentityModel.Tokens.Jwt;
using System;

namespace Auvenir.Libraries.Common.Helpers
{
    public class CommonHelper
    {
        public static string GetDictionaryValue(IDictionary<string, object> keyValuePairs, string paraName)
        {
            return !string.IsNullOrEmpty(paraName) && keyValuePairs.ContainsKey(paraName) ? keyValuePairs[paraName].ToString() : string.Empty;
        }

        public static object GetDictionaryObject(IDictionary<string, object> keyValuePairs, string paraName)
        {
            return !string.IsNullOrEmpty(paraName) && keyValuePairs.ContainsKey(paraName) ? keyValuePairs[paraName] : null;
        }

        public static string GetHtmlEncoded(string data)
        {
            return System.Net.WebUtility.HtmlEncode(data);
        }

        public static string GetHtmlDecoded(string data)
        {
            if (string.IsNullOrEmpty(data)) return string.Empty;
            return System.Net.WebUtility.HtmlDecode(data);
        }

        /// <summary>
        /// Decode HTML encoded characters in properties of object
        /// </summary>
        /// <param name="obj">the object</param>
        /// <param name="fieldNames">list of property names</param>
        public static void SetHtmlDecodedFields<T>(T obj, List<string> fieldNames) where T : class
        {
            fieldNames.ForEach(_ =>
            {
                List<PropertyInfo> propertyInfos = ObjectExtension.GetPropertyInfos(obj).Where(x => fieldNames.Contains(x.Name)).ToList();
                propertyInfos.ForEach(propertyInfo =>
                {
                    if (fieldNames.Contains(propertyInfo.Name))
                    {
                        var value = propertyInfo.GetValue(obj);
                        if (value is string && !string.IsNullOrEmpty((string)value))
                        {
                            propertyInfo.SetValue(obj, GetHtmlDecoded((string)value));
                        }
                    }
                });
            });
        }

        public static void UnescapeHtmlCharacters<T>(T obj, string fieldName) where T : class
        {
            SetHtmlDecodedFields(obj, new List<string>() { fieldName });
        }

        public static void UnescapeHtmlCharacters<T>(T obj, List<string> fieldNames) where T : class
        {
            SetHtmlDecodedFields(obj, fieldNames);
        }

        public static Dictionary<string, string> GetMimeTypes()
        {
            return new Dictionary<string, string>
            {
                {".txt", "text/plain"},
                {".pdf", "application/pdf"},
                {".doc", "application/vnd.ms-word"},
                {".docx", "application/vnd.ms-word"},
                {".xls", "application/vnd.ms-excel"},
                {".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"},
                {".png", "image/png"},
                {".jpg", "image/jpeg"},
                {".jpeg", "image/jpeg"},
                {".gif", "image/gif"},
                {".csv", "text/csv"}
            };
        }

        public static string GetContentType(string path)
        {
            var types = GetMimeTypes();
            var ext = Path.GetExtension(path).ToLowerInvariant();
            return types[ext];
        }

        /// <summary>
        /// Replace Hexadecimal Symbols
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static string ReplaceHexadecimalSymbols(string input)
        {
            const string pattern = @"\p{Cc}";
            var inputEncode = GetHtmlDecoded(input);
            return Regex.Replace(inputEncode, pattern, string.Empty, RegexOptions.Compiled);
        }

        /// <summary>
        /// Check token is expired or NOT. Return true if it is expired or jwtToken.ValidTo.AddMinutes(-expiredBeforeMinutes) < DateTime.UtcNow
        /// </summary>
        /// <param name="token">token</param>
        /// <param name="expiredBeforeMinutes">expired Before Minutes</param>
        /// <returns>bool</returns>
        public static bool IsEmptyOrInvalidToken(string token, double expiredBeforeMinutes)
        {
            try
            {
                if (string.IsNullOrEmpty(token))
                {
                    return true;
                }
                JwtSecurityToken jwtToken = new JwtSecurityTokenHandler().ReadToken(token) as JwtSecurityToken;
                return (jwtToken == null)
                    || (jwtToken.ValidFrom > DateTime.UtcNow)
                    || (jwtToken.ValidTo.AddMinutes(-expiredBeforeMinutes) < DateTime.UtcNow);
            }
            catch (Exception ex)
            {
                return true;
            }
        }
    }
}