using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Auvenir.Libraries.Common.Helpers
{
    public static class ValidatorHelper
    {
        /// <summary>
        /// Check type is numberic.
        /// </summary>
        /// <param name="type"> data type</param>
        /// <returns>true: numberic; false: not numberic</returns>
        public static bool CheckNumberic(dynamic type)
        {
            try
            {
                var data = Convert.ToString(type);
                // pattern check for an integer or float number such as 1, -1, 1.1, -1.1
                Regex regex = new Regex(@"^-?\d+(\.\d+)?$");
                if (String.IsNullOrWhiteSpace(data))
                {
                    return false;
                }
                if (!regex.IsMatch(data))
                {
                    return false;
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static bool CheckDouble(dynamic value)
        {
            try
            {
                var data = Convert.ToString(value);
                // pattern check for an integer or float number such as 1, -1, 1.1, -1.1
                Regex regexNormalDouble = new Regex(@"^-?\d+(\.\d+)?$");
                // pattern check for a negative number such as the this format: (123)
                Regex regexNegativeDouble = new Regex(@"^\(?\d+(\.\d+)?\)?$");

                if (String.IsNullOrWhiteSpace(data))
                {
                    return false;
                }
                if (regexNormalDouble.IsMatch(data))
                {
                    return true;
                }
                if (regexNegativeDouble.IsMatch(data))
                {
                    return true;
                }
                return false;
            }
            catch
            {
                return false;
            }
        }

        public static bool CheckPositiveNumber(dynamic value)
        {
            try
            {
                var data = Convert.ToString(value);
                Regex regex = new Regex(@"^\d+(\.\d+)?$");

                if (String.IsNullOrWhiteSpace(data) || !regex.IsMatch(data) || Convert.ToDouble(value) < 0)
                {
                    return false;
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        public static void ThrowExceptionIfAnyIsNull(params dynamic[] objects)
        {
            foreach (var obj in objects)
            {
                if (obj == null)
                {
                    throw new NullReferenceException(string.Format(Constants.Constants.ErrorDataIsNull, nameof(obj)));
                }
            }
        }

        /// <summary>
        /// Throws an exception if 2 collections have different size
        /// </summary>
        /// <typeparam name="U"></typeparam>
        /// <typeparam name="V"></typeparam>
        /// <param name="col1"></param>
        /// <param name="col2"></param>
        /// <exception cref="InvalidOperationException"></exception>
        public static void ThrowExceptionIfNotEqualQuantity<U,V>(ICollection<U> col1, ICollection<V> col2)
        {
            if (col1 == null || col2 == null || col1.Count != col2.Count)
            {
                throw new InvalidOperationException(string.Format(Constants.Constants.ErrorNotEqualQuantity, nameof(col1), nameof(col2)));
            }
        }
    }
}