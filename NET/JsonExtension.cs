using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Auvenir.Libraries.Common.Extensions
{
    public static class JsonExtension
    {
        public static T ToObject<T>(this string json)
        {
            return json.IsJson() ? JsonConvert.DeserializeObject<T>(json) : default(T);
        }

        public static string ConvertToJson<T>(T obj)
        {
            try
            {
                return JsonConvert.SerializeObject(obj);
            }
            catch
            {
                return JsonConvert.SerializeObject(default(T));
            }
        }

        public static T ConvertToObject<T>(string json)
        {
            return json.IsJson() ? JsonConvert.DeserializeObject<T>(json) : default(T);
        }

        private static bool IsJson(this string text)
        {
            if (string.IsNullOrEmpty(text))
            {
                return false;
            }
            if ((text.StartsWith("{") && text.EndsWith("}")) || //For object
            (text.StartsWith("[") && text.EndsWith("]"))) //For array
            {
                JToken.Parse(text);
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}