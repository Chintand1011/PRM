using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace PatientPortal.Utility
{
    public static class CryptorEngine
    {

        private static string AesIV256 { get { return ConfigurationManager.AppSettings["AesIV256"]; } }
        private static string AesKey256 { get { return ConfigurationManager.AppSettings["AesKey256"]; } }

        public static string Encrypt(string encryptString)
        {
            if (string.IsNullOrEmpty(encryptString))
                return string.Empty;

            // AesCryptoServiceProvider
            var aes = new AesCryptoServiceProvider
            {
                BlockSize = 128,
                KeySize = 256,
                IV = Encoding.UTF8.GetBytes(AesIV256),
                Key = Encoding.UTF8.GetBytes(AesKey256),
                Mode = CipherMode.CBC,
                Padding = PaddingMode.PKCS7
            };

            // Convert string to byte array
            var src = Encoding.Unicode.GetBytes(encryptString);

            // encryption
            using (var encrypt = aes.CreateEncryptor())
            {
                var dest = encrypt.TransformFinalBlock(src, 0, src.Length);

                // Convert byte array to Base64 strings
                return Convert.ToBase64String(dest);
            }
        }

        public static string Decrypt(string encryptedString)
        {
            if (string.IsNullOrEmpty(encryptedString))
                return string.Empty;

            try
            {
                // AesCryptoServiceProvider
                var aes = new AesCryptoServiceProvider
                {
                    BlockSize = 128,
                    KeySize = 256,
                    IV = Encoding.UTF8.GetBytes(AesIV256),
                    Key = Encoding.UTF8.GetBytes(AesKey256),
                    Mode = CipherMode.CBC,
                    Padding = PaddingMode.PKCS7
                };

                // Convert Base64 strings to byte array
                var src = Convert.FromBase64String(encryptedString);

                // decryption
                using (var decrypt = aes.CreateDecryptor())
                {
                    var dest = decrypt.TransformFinalBlock(src, 0, src.Length);
                    return Encoding.Unicode.GetString(dest);
                }
            }
            catch (Exception)
            {
                return string.Empty;
            }
        }

       

    }

}
