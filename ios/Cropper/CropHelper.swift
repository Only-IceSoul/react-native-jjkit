//
//  CropHelper.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 5/5/20.
//

import UIKit
import Accelerate


class CropHelper {
    

    static func crop(_ image:CGImage,imageRect:CGRect,cw:CGFloat,ch:CGFloat,crop: CGRect) -> CGRect {
        let w = crop.width / imageRect.width * CGFloat(image.width)
        let h = crop.height / imageRect.height * CGFloat(image.height)
        var x:CGFloat = crop.origin.x
        var y:CGFloat = crop.origin.y
        if imageRect.origin.x < 0 {
            x = abs(imageRect.origin.x) + crop.origin.x
        }else if imageRect.origin.x > 0 {
            x = crop.origin.x - imageRect.origin.x
        }
        if imageRect.origin.y < 0 {
            y = abs(imageRect.origin.y) + crop.origin.y
        }else if imageRect.origin.y > 0 {
              y = crop.origin.y - imageRect.origin.y
        }
        
        x = x / imageRect.width * CGFloat(image.width)
        y = y / imageRect.height * CGFloat(image.height)
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    static func centerRect(width:CGFloat,height:CGFloat,cw:CGFloat,ch:CGFloat) -> CGRect{
       
           if(width == cw && height == ch){
               return CGRect(x: 0, y: 0, width: cw, height: ch)
           }
           
           let x = cw / 2 - width/2
           let y = ch / 2 - height/2

           return CGRect(x: x, y: y, width: width, height: height)
           
       }
      
      //clockwise
     static func getSizeRotated(image:CGImage, degree:CGFloat,cx:CGFloat,cy:CGFloat)->CGSize {
         
         let radian = (degree * .pi / 180) * -1
         var left:CGFloat = 0
         var top:CGFloat = 0
         let xAx = cos(radian )
         let xAy = sin(radian )
         let w = CGFloat(image.width)
         let h = CGFloat(image.height)
         left -= cx;
         top -= cy;
         
         let tlX = left * xAx - top * xAy + cx
         let tlY = left * xAy + top * xAx + cy
         let trX = (left + w) * xAx - top * xAy + cx
         let trY = (left + w) * xAy + top * xAx + cy
         let brX = (left + w) * xAx - (top + h) * xAy + cx
         let brY = (left + w) * xAy + (top + h) * xAx + cy
         let blX = left * xAx - (top + h) * xAy + cx
         let blY = left * xAy + (top + h) * xAx + cy
         
         let w1 = abs(brX - tlX)
         let h1 = abs(brY - tlY)
         let w2 = abs(trX - blX)
         let h2 = abs(blY - trY)
     
         return .init(width: max(w1,w2), height: max(h1,h2))
            
            
        }
     
     static func createImageCentered(_ cgImage:CGImage,width:CGFloat,height:CGFloat,backColor:CGColor? = nil)-> CGImage? {
     
         let rect = centerRect(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height), cw: width, ch: height)
         guard let context = CGContext(data: nil,
                                       width: Int(width + 0.5),
                                       height: Int(height + 0.5),
                                       bitsPerComponent: 8,
                                       bytesPerRow: 0,
                                       space:  cgImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
           
             else { return nil }


         // draw image to context (resizing it)
         context.interpolationQuality = .high
         if backColor != nil {
             context.setFillColor(UIColor.black.cgColor)
             context.fill(CGRect(x: 0, y: 0, width: context.width, height: context.height))
         }
         context.draw(cgImage, in: rect)
         

         // extract resulting image from context
         return context.makeImage()
         
     }
     
     
     //clockwise
     static func rotateContent(_ cgImage:CGImage,degree:CGFloat) -> CGImage?{
         // Define the image format
         
         let radians = Float((degree * .pi / 180) * -1)
         var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                     bitsPerPixel: 32,
                                     colorSpace: nil,
                                     bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
                                     version: 0,
                                     decode: nil,
                                     renderingIntent: CGColorRenderingIntent.defaultIntent)



         //create source buffer
         var sourceBuffer = vImage_Buffer()
         defer { free(sourceBuffer.data) }
         var error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                             &format,
                                             nil,
                                             cgImage,
                                             numericCast(kvImageNoFlags))
         guard error == kvImageNoError else { return nil }

         // create a destination buffer
         var destinationBuffer = vImage_Buffer()
         defer { free(destinationBuffer.data) }
         error = vImageBuffer_Init(&destinationBuffer,
                                   vImagePixelCount(cgImage.height),
                                   vImagePixelCount(cgImage.width),
                               format.bitsPerPixel,
                               vImage_Flags(kvImageNoFlags))

         guard error == kvImageNoError else { return nil }

         // rotate the image
      
         var backColor = UInt8(0)
         error = vImageRotate_ARGB8888(&sourceBuffer,
                                       &destinationBuffer,
                                       nil,
                                       radians,
                                       &backColor,
                                       vImage_Flags(kvImageBackgroundColorFill))

         guard error == kvImageNoError else { return nil }

         // create a CGImage from vImage_Buffer
         guard let rotatedImage = vImageCreateCGImageFromBuffer(&destinationBuffer,
                                                           &format,
                                                           nil,
                                                           nil,
                                                           numericCast(kvImageNoFlags),
                                                           &error)?.takeRetainedValue()
         ,error == kvImageNoError
         else { return nil }

         // create a UIImage


         return   rotatedImage
     }

  
}
