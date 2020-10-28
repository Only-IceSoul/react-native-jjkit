//
//  GuisoTransform.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit
import Accelerate

public class TransformationUtils {
    
    
    //MARK: Transform
    
    public static func fitCenter(image: UIImage,width: CGFloat,height:CGFloat,lanczos:Bool = false) -> UIImage? {
      let inWidth = image.size.width
      let inHeight = image.size.height
      
      if(inWidth == width && inHeight == height){
          return image
      }
      
      let widthPercentage = width / inWidth
      let heightPercentage = height / inHeight
      let minPercentage = min(widthPercentage, heightPercentage)
      
      let targetWidth = round(minPercentage * inWidth)
      let targetHeight = round(minPercentage * inHeight)
      
      if(inWidth == targetWidth && inHeight == targetHeight){
         return image
      }
      
      let finalW = Int(minPercentage * inWidth)
      let finalH = Int(minPercentage * inHeight)
      
        return lanczos ? resizeVImage(image:image, targetWidth: CGFloat(finalW), targetHeight:CGFloat(finalH))
            : resizeImage(image: image, targetWidth: CGFloat(finalW), targetHeight:  CGFloat(finalH))
      
    }
   public static func centerCrop(image:UIImage,width:CGFloat,height:CGFloat,lanczos:Bool = false) -> UIImage? {
       let inWidth = image.size.width
       let inHeight = image.size.height

       if(inWidth == width && inHeight == height){
         return image
       }
             
       var dx:CGFloat = 0
       var dy:CGFloat = 0
       var scale:CGFloat = 1
       
       if inWidth * height > width * inHeight {
           scale = height / inHeight
           dx = (width - inWidth * scale) * 0.5
           dy = 0
       }else{
           scale = width / inWidth
           dy = (height - inHeight * scale) * 0.5
           dx = 0
       }
       
       
       let scaleW = scale * inWidth
       let scaleH = scale * inHeight
       
       let newSize = CGSize(width: width, height: height)
       let centerRect = CGRect(x: dx, y: dy, width: scaleW, height: scaleH)
        return  resizeImage(image:image, bitmapSize: newSize, drawRect: centerRect)
       
    }
    
    public static func fitCenter(cgImage: CGImage,width: CGFloat,height:CGFloat, lanczos:Bool = false) -> CGImage? {
        let inWidth = CGFloat(cgImage.width)
        let inHeight = CGFloat(cgImage.height)
        
        if(inWidth == width && inHeight == height){
            return cgImage
        }
       
        let widthPercentage = width / inWidth
        let heightPercentage = height / inHeight
        let minPercentage = min(widthPercentage, heightPercentage)
        
        let targetWidth = round(minPercentage * inWidth)
        let targetHeight = round(minPercentage * inHeight)
        
        if(inWidth == targetWidth && inHeight == targetHeight){
           return cgImage
        }
       
       let finalW = Int(minPercentage * inWidth)
       let finalH = Int(minPercentage * inHeight)
       
       return lanczos ? resizeVImage(cgImage: cgImage, CGFloat(finalW), CGFloat(finalH)) :
        resizeImage(cgImage: cgImage,targetWidth: CGFloat(finalW), targetHeight: CGFloat(finalH))
        
    }
       
    public static func centerCrop(cgImage:CGImage,width:CGFloat,height:CGFloat, lanczos:Bool = false) -> CGImage? {
        let inWidth = CGFloat(cgImage.width)
        let inHeight = CGFloat(cgImage.height)
        
        if(inWidth == width && inHeight == height){
         return cgImage
        }
             
        var dx:CGFloat = 0
        var dy:CGFloat = 0
        var scale:CGFloat = 1

        if inWidth * height > width * inHeight {
           scale = height / inHeight
           dx = (width - inWidth * scale) * 0.5
           dy = 0
        }else{
           scale = width / inWidth
           dy = (height - inHeight * scale) * 0.5
           dx = 0
        }


        let scaleW = scale * inWidth
        let scaleH = scale * inHeight

        let newSize = CGSize(width: width, height: height)
        let centerRect = CGRect(x: dx, y: dy, width: scaleW, height: scaleH)
        
        return  resizeImage(cgImage:cgImage, bitmapSize: newSize, drawRect: centerRect)

    }
    
    //MARK: Resize UIIMage
    
    public static func resizeImage(image:UIImage, bitmapSize: CGSize , drawRect: CGRect) -> UIImage?{
               UIGraphicsBeginImageContextWithOptions(bitmapSize, false, 1.0)
               image.draw(in: drawRect)
               let newImage = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
          return newImage
    }
    
   public static func resizeImage(image:UIImage, targetWidth:CGFloat,targetHeight:CGFloat) -> UIImage?{
       let newSize = CGSize(width: targetWidth, height: targetHeight)
       let centerRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
       UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
       image.draw(in: centerRect)
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return newImage
    }

    public static func resizeVImage(image:UIImage,targetWidth: CGFloat,targetHeight:CGFloat) -> UIImage?{
       
       // Decode the source image
      let cgImage = image.cgImage!
       
       // Define the image format
       var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                   bitsPerPixel: 32,
                                   colorSpace: nil,
                                   bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
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
                               vImagePixelCount(Int(targetHeight)),
                               vImagePixelCount(Int(targetWidth)),
                               format.bitsPerPixel,
                               vImage_Flags(kvImageNoFlags))

       guard error == kvImageNoError else { return nil }

       // scale the image
       error = vImageScale_ARGB8888(&sourceBuffer,
                               &destinationBuffer,
                               nil,
                               numericCast(kvImageHighQualityResampling))
       guard error == kvImageNoError else { return nil }
       
      
       // create a CGImage from vImage_Buffer
       guard let resizedCGImage = vImageCreateCGImageFromBuffer(&destinationBuffer,
                                                           &format,
                                                           nil,
                                                           nil,
                                                           numericCast(kvImageNoFlags),
                                                           &error)?.takeRetainedValue()
       ,error == kvImageNoError
       else { return nil }

       // create a UIImage

       return  UIImage(cgImage: resizedCGImage)
    }
    
    
    //MARK: resize cgImage
    
    public static func resizeImage(cgImage:CGImage,targetWidth: CGFloat, targetHeight:CGFloat) -> CGImage?{
         
        
         let newSize = CGSize(width: Int(targetWidth), height: Int(targetHeight))
         let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
         
         guard let context = CGContext(data: nil,
                                       width: Int(targetWidth),
                                       height: Int(targetHeight),
                                       bitsPerComponent: 8,
                                       bytesPerRow: 0,
                                       space:  cgImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
             else { return nil }


         // draw image to context (resizing it)
         context.interpolationQuality = .high
         context.draw(cgImage, in: rect)

         // extract resulting image from context
         return context.makeImage()
     
     }
    
    
    
    public static func resizeImage(cgImage:CGImage, bitmapSize: CGSize , drawRect: CGRect) -> CGImage?{
       
             guard let context = CGContext(data: nil,
                                           width: Int(bitmapSize.width),
                                           height: Int(bitmapSize.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: cgImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
             else { return nil }


             context.interpolationQuality = .high
             context.draw(cgImage, in: drawRect)

             return context.makeImage()

      }

    public static func resizeVImage(cgImage: CGImage,_ targetWidth: CGFloat,_ targetHeight:CGFloat) -> CGImage?{
           
           
           
           // Define the image format
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
                                   vImagePixelCount(Int(targetHeight)),
                                   vImagePixelCount(Int(targetWidth)),
                                   format.bitsPerPixel,
                                   vImage_Flags(kvImageNoFlags))

           guard error == kvImageNoError else { return nil }

           // scale the image
           error = vImageScale_ARGB8888(&sourceBuffer,
                                   &destinationBuffer,
                                   nil,
                                   numericCast(kvImageHighQualityResampling))
           guard error == kvImageNoError else { return nil }

           // create a CGImage from vImage_Buffer
           guard let resizedCGImage = vImageCreateCGImageFromBuffer(&destinationBuffer,
                                                               &format,
                                                               nil,
                                                               nil,
                                                               numericCast(kvImageNoFlags),
                                                               &error)?.takeRetainedValue()
           ,error == kvImageNoError
           else { return nil }

           // create a UIImage


           return   resizedCGImage
       }
      
    
    public static func cleanImage(_ img:UIImage) -> UIImage{
        let cg = img.cgImage!
        let result = resizeImage(cgImage: cg, targetWidth: CGFloat(cg.width), targetHeight: CGFloat(cg.height))
        
        return result != nil ? UIImage(cgImage: result!) : img
    }

    
    //MARK: Gif
    
   public static func cleanGif(_ gif:AnimatedImage) -> AnimatedImage {
               
        var framesResult = [CGImage]()


        for i in 0...(gif.frames.count-1){

          let img = gif.frames[i]
          let result =
            resizeImage(cgImage: img, targetWidth: CGFloat(img.width), targetHeight: CGFloat(img.height))
          if result != nil {
              framesResult.append(result!)
          }
          
        }
    
        let result = AnimatedImage()
        result.frames =  framesResult
        result.duration = gif.duration
        result.loopCount = gif.loopCount
        result.delays = gif.delays
        result.bytesCount = gif.bytesCount
        return  result

    }
    
    
    //MARK: Filters
    
    public static func convertToGrayScale(image: UIImage) -> UIImage? {

        // Create image rectangle with current image width/height
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil,
                             width: Int(width),
                             height: Int(height),
                        bitsPerComponent: 8,
                        bytesPerRow: 0,
                        space: colorSpace,
                        bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
       guard  let imageRef = context?.makeImage()
        else{ return nil }
        
        let newImage = UIImage(cgImage: imageRef)
        return newImage
    }
    
    public static func convertToGrayScale(cg: CGImage) -> CGImage? {

        // Create image rectangle with current image width/height
        let imageRect:CGRect = CGRect(x:0, y:0, width:cg.width, height: cg.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = cg.width
        let height = cg.height
        
        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil,
                             width: Int(width),
                             height: Int(height),
                        bitsPerComponent: 8,
                        bytesPerRow: 0,
                        space: colorSpace,
                        bitmapInfo: bitmapInfo.rawValue)
        context?.draw(cg, in: imageRect)
       guard  let imageRef = context?.makeImage()
        else{ return nil }
        
        return imageRef
    }
    
    
    //MARK: Rect
    
    static func getRect(cgImage:CGImage,width:CGFloat,height:CGFloat,_ scaleType: UIView.ContentMode) -> CGRect{
        switch scaleType {
        case .scaleAspectFill:
            return rectCenterCrop(cgImage: cgImage, width: width, height: height)
        case .scaleAspectFit:
            return rectFitCenter(cgImage: cgImage, width: width, height: height)
        default:
            return CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
    
    static func getRect(image:UIImage,width:CGFloat,height:CGFloat,_ scaleType: UIView.ContentMode) -> CGRect{
             switch scaleType {
             case .scaleAspectFill:
                 return rectCenterCrop(image: image, width: width, height: height)
             case .scaleAspectFit:
             
                 return rectFitCenter(image: image, width: width, height: height)
             default:
                   
                 return CGRect(x: 0, y: 0, width: width, height: height)
             }
         }
       

       
     
       
       static func rectFitCenter(image: UIImage,width: CGFloat,height:CGFloat) -> CGRect {
           let inWidth = image.size.width
           let inHeight = image.size.height
           
           if(inWidth == width && inHeight == height){
               return CGRect(x: 0, y: 0, width: width, height: height)
           }
           
           let widthPercentage = width / inWidth
           let heightPercentage = height / inHeight
           let minPercentage = min(widthPercentage, heightPercentage)
           
           let targetWidth = round(minPercentage * inWidth)
           let targetHeight = round(minPercentage * inHeight)
           
           if(width == targetWidth && height == targetHeight){
              return CGRect(x: 0, y: 0, width: width, height: height)
           }
           
           let dx = (width - targetWidth) / 2
           let dy = (height - targetHeight) / 2
        
   
       
           return CGRect(x: dx, y: dy, width: targetWidth, height: targetHeight)
           
       }
       
       static func rectCenterCrop(image:UIImage,width:CGFloat,height:CGFloat) -> CGRect {
           let inWidth = image.size.width
           let inHeight = image.size.height
           
           if(inWidth == width && inHeight == height){
             return CGRect(x: 0, y: 0, width: width, height: height)
           }
                
           var dx:CGFloat = 0
           var dy:CGFloat = 0
           var scale:CGFloat = 1

           if inWidth * height > width * inHeight {
              scale = height / inHeight
              dx = (width - inWidth * scale) * 0.5
              dy = 0
           }else{
              scale = width / inWidth
              dy = (height - inHeight * scale) * 0.5
              dx = 0
           }
           let scaleW = scale * inWidth
           let scaleH = scale * inHeight
          return  CGRect(x: dx, y: dy, width: scaleW, height: scaleH)
       }
       
       static func rectFitCenter(cgImage: CGImage,width: CGFloat,height:CGFloat) -> CGRect {
           let inWidth = CGFloat(cgImage.width)
           let inHeight = CGFloat(cgImage.height)
           if(inWidth == width && inHeight == height){
               return CGRect(x: 0, y: 0, width: width, height: height)
           }
           
           let widthPercentage = width / inWidth
           let heightPercentage = height / inHeight
           let minPercentage = min(widthPercentage, heightPercentage)
           let targetWidth = round(minPercentage * inWidth)
           let targetHeight = round(minPercentage * inHeight)
           if(width == targetWidth && height == targetHeight){
              return CGRect(x: 0, y: 0, width: width, height: height)
           }
           
           let dx = (width - targetWidth) / 2
           let dy = (height - targetHeight) / 2
        
       
           return CGRect(x: dx, y: dy, width: targetWidth, height: targetHeight)
           
       }
       
       static func rectCenterCrop(cgImage:CGImage,width:CGFloat,height:CGFloat) -> CGRect {
           let inWidth = CGFloat(cgImage.width)
           let inHeight = CGFloat(cgImage.height)
           
           if(inWidth == width && inHeight == height){
             return CGRect(x: 0, y: 0, width: width, height: height)
           }
                
           var dx:CGFloat = 0
           var dy:CGFloat = 0
           var scale:CGFloat = 1

           if inWidth * height > width * inHeight {
              scale = height / inHeight
              dx = (width - inWidth * scale) * 0.5
              dy = 0
           }else{
              scale = width / inWidth
              dy = (height - inHeight * scale) * 0.5
              dx = 0
           }
           let scaleW = scale * inWidth
           let scaleH = scale * inHeight
          return  CGRect(x: dx, y: dy, width: scaleW, height: scaleH)
       }
       
}
