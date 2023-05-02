using System;
using System.Drawing.Imaging;
using System.IO;
namespace PatientPortal.Utility
{
    public static class SigPlusNet
    {
        public static byte[] GetImageBytesFromClientSign(string clientSign)
        {
            //Put user code to initialize the page here
            var sigObj = new Topaz.SigPlusNET();

            sigObj.SetSigCompressionMode(1);
            //Now, get sigstring from client
            //Sigstring can be stored in a database if 
            //a biometric signature is desired rather than an image

            sigObj.SetSigString(clientSign);

            if (sigObj.NumberOfTabletPoints() > 0)
            {
                sigObj.SetImageFileFormat(0);
                sigObj.SetImageXSize(500);
                sigObj.SetImageYSize(150);
                sigObj.SetImagePenWidth(8);
                sigObj.SetJustifyX(5);
                sigObj.SetJustifyY(5);
                sigObj.SetJustifyMode(5);
                var image = sigObj.GetSigImage();
                
                using (var stream = new MemoryStream())
                {
                    image.Save(stream, ImageFormat.Png);
                    return stream.ToArray();
                }

            }

            return new byte[1];

        }
    }
}
