using System;
using System.ComponentModel;
using System.Linq;
using System.Reflection;

namespace Auvenir.Libraries.Common.Helpers
{
    public static class EnumHelper
    {
        public static string Value(this Enum enumeration)
        {
            return enumeration.GetAttributeValue<DescriptionAttribute, string>(x => x.Description);
        }

        private static TExpected GetAttributeValue<T, TExpected>(this Enum enumeration, Func<T, TExpected> expression) where T : Attribute
        {
            var item = enumeration.GetType().GetMember(enumeration.ToString())
                .FirstOrDefault(member => member.MemberType == MemberTypes.Field);
            var result = default(TExpected);
            if (item == null) return result;
            var attribute = item
                .GetCustomAttributes(typeof(T), false)
                .Cast<T>()
                .SingleOrDefault();
            if (attribute != null)
            {
                result = expression(attribute);
            }
            return result;
        }
    }
}