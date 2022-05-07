using System.Drawing;
using System;

namespace SimpleGaussianBlur
{
    class Program
    {
        static void Main(string[] args)
        {
            // Demo code from lecture -> Remove this if not required any more
            //DemoExample.DoStuff();

            using (var inputImage = new Bitmap("./InputImage.bmp"))
            {
                // For testing purposes: .NET implementation without using OpenCL -> Remove this if not required any more
                //var outputImage = GaussianNet.ApplyGaussianBlur(inputImage);
                var outputImage = GaussianOpenCl.ApplyGaussianBlur(inputImage);
                outputImage.Save("./OutputImage.bmp");
            }

            Console.WriteLine("Program finished.\nPress RETURN to exit the program.");
            Console.ReadLine();
        }
    }
}
