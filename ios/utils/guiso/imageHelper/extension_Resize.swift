//
//  extension_ImageHelper_Resize.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/26/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit
import Accelerate


extension ImageHelper {

    
    static func resizeSampling(image: UIImage, request: CGSize) -> UIImage? {
     
        let w = image.size.width
        let h = image.size.height
        var inSampleSize : CGFloat = 1

        if w > 0 && h > 0
        && ( w > request.width || h > request.height) {

            while h / inSampleSize > request.height || w / inSampleSize > request.width {
             inSampleSize *= 2
                }
            let newWidth = w / inSampleSize
            let newHeight = h / inSampleSize
          
            return resizeImage(image, targetWidth: newWidth, targetHeight: newHeight)
            
        }else {
            return image
        }
    }
    
    static func resizeImage(_ image:UIImage, bitmapSize: CGSize , drawRect: CGRect) -> UIImage?{
            UIGraphicsBeginImageContextWithOptions(bitmapSize, false, 1.0)
            image.draw(in: drawRect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
       return newImage
   }

    static func resizeImage(_ image:UIImage, targetWidth:CGFloat,targetHeight:CGFloat) -> UIImage?{
        let newSize = CGSize(width: targetWidth, height: targetHeight)
        let centerRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: centerRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func resizeVImage(url : URL,_ targetWidth: CGFloat,_ targetHeight:CGFloat) -> UIImage?{
        
        // Decode the source image
          guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
              let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
              let imageWidth = properties[kCGImagePropertyPixelWidth] as? vImagePixelCount,
              let imageHeight = properties[kCGImagePropertyPixelHeight] as? vImagePixelCount
          else {
              return nil
          }
        
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
                                            image,
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
    
    static func resizeVImage(_ image:UIImage,_ targetWidth: CGFloat,_ targetHeight:CGFloat) -> UIImage?{
         
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
    
    static func resizeVImage(cgImage: CGImage,_ targetWidth: CGFloat,_ targetHeight:CGFloat) -> CGImage?{
         
         
         
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
    
    
    
    
    static func resizeImage(cgImage:CGImage, bitmapSize: CGSize , drawRect: CGRect) -> CGImage?{
     
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

    static func resizeImage(_ url:URL,_ targetWidth: CGFloat,_ targetHeight:CGFloat) -> CGImage?{
         
         guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
                let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                return nil
            }
         
         let newSize = CGSize(width: Int(targetWidth), height: Int(targetHeight))
         let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

         guard let context = CGContext(data: nil,
                                       width: Int(targetWidth),
                                       height: Int(targetHeight),
                                       bitsPerComponent: 8,
                                       bytesPerRow: 0,
                                       space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
             else { return nil }

     
         // draw image to context (resizing it)
         context.interpolationQuality = .high
         context.draw(image, in: rect)

         // extract resulting image from context
         return context.makeImage()
     }
     
    static func resizeImage(_ cgImage:CGImage,_ targetWidth: CGFloat,_ targetHeight:CGFloat) -> CGImage?{
         

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
    
    static func scaleContentVImage(cgImage:CGImage,scale:Float,linear:Bool = false) -> CGImage? {
        
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                            bitsPerPixel: 32,
                                            colorSpace: nil,
                                            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                            version: 0,
                                            decode: nil,
                                            renderingIntent: CGColorRenderingIntent.defaultIntent)
        
          var sourceBuffer = vImage_Buffer()
            defer { free(sourceBuffer.data) }
            var error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                                        &format,
                                                        nil,
                                                        cgImage,
                                                        numericCast(kvImageNoFlags))
         guard error == kvImageNoError else { return nil }
        
     
        
         var intermediateBuffer = vImage_Buffer()
         defer { free(intermediateBuffer.data) }
           error =  vImageBuffer_Init(&intermediateBuffer,
                                      vImagePixelCount(Int(sourceBuffer.height)),
                                      vImagePixelCount(Int(sourceBuffer.width)),
                                            format.bitsPerPixel,
                                            vImage_Flags(kvImageNoFlags))
         guard error == kvImageNoError else { return nil }
        
         var destinationBuffer = vImage_Buffer()
        defer { free(destinationBuffer.data) }
          error = vImageBuffer_Init(&destinationBuffer,
                                    vImagePixelCount(Int(sourceBuffer.height)),
                                    vImagePixelCount(Int(sourceBuffer.width)),
                                  format.bitsPerPixel,
                                  vImage_Flags(kvImageNoFlags))

          guard error == kvImageNoError else { return nil }
        
       
          let resamplingFilter: ResamplingFilter
          
        
          if linear {
              // A linear interpolation resampling function. The
              // `inPointer` contains a series of pixel distances
              // from the current pixel. The function writes a set
              // of kernel weights to `outPointer`.
              func kernelFunc(inPointer: UnsafePointer<Float>?,
                              outPointer: UnsafeMutablePointer<Float>?,
                              count: UInt,
                              userData: UnsafeMutableRawPointer?) {
                  if let inPointer = inPointer, let outPointer = outPointer {
                      let absolutePixelPositions =
                          Array(UnsafeBufferPointer(start: inPointer,
                                                    count: Int(count))).map {
                                                      abs($0)
                          }

                      let kernelValues = absolutePixelPositions.map {
                          (absolutePixelPositions.max()! - $0)
                      }
                      
                      let normalizedKernelValues = kernelValues.map {
                          $0 / kernelValues.reduce(0, +)
                      }
                      
                      outPointer.assign(from: normalizedKernelValues,
                                        count: Int(count))
                  }
              }
              
              // Given a specified kernel width, calculate and allocate
              // the memory required for the resampling filter.
              let kernelWidth: Float = 1.5
              
            let size = vImageGetResamplingFilterSize(scale,
                                                       kernelFunc,
                                                       kernelWidth,
                                                       vImage_Flags(kvImageNoFlags))
              
              resamplingFilter = ResamplingFilter.allocate(byteCount: size,
                                                           alignment: 1)
              
              // Populate `resamplingFilter` with the custom linear
              // resampling filter.
              vImageNewResamplingFilterForFunctionUsingBuffer(resamplingFilter,
                                                              scale,
                                                              kernelFunc,
                                                              kernelWidth,
                                                              nil,
                                                              vImage_Flags(kvImageNoFlags))
          } else {
              // Create a high-quality Lanczos resampling filter.
            resamplingFilter = vImageNewResamplingFilter(scale,
                                            vImage_Flags(kvImageHighQualityResampling))
              
          }
          // Perform a 2D scale about the center of the buffer in two separate passes.
          var backColor = UInt8(0)
        let height = Float(sourceBuffer.height)
        let width = Float(sourceBuffer.width)
        let xTranslate = (width - width * scale) * 0.5
        let yTranslate = (height - height * scale) * 0.5
          vImageVerticalShear_ARGB8888(&sourceBuffer,
                                       &intermediateBuffer,
                                        0, 0,
                                       yTranslate,
                                       0,
                                       resamplingFilter,
                                       &backColor,
                                       vImage_Flags(kvImageNoFlags))
     
          
          vImageHorizontalShear_ARGB8888(&intermediateBuffer,
                                         &destinationBuffer,
                                         0, 0,
                                         xTranslate,
                                         0,
                                         resamplingFilter,
                                         &backColor,
                                         vImage_Flags(kvImageNoFlags))
          // Release the resampling filter using correct approach for type.
          if linear  {
              resamplingFilter.deallocate()
          } else {
              vImageDestroyResamplingFilter(resamplingFilter)
          }
        
        
          guard let scaledContent = vImageCreateCGImageFromBuffer(&destinationBuffer,
                                                                     &format,
                                                                     nil,
                                                                     nil,
                                                                numericCast(kvImageNoFlags),
                                                                &error)?.takeRetainedValue()
                 ,error == kvImageNoError
                 else { return nil }
          
           return scaledContent
      }
  
     static func scaleContentVImage(image: UIImage,scale:Float,linear:Bool = false) -> UIImage? {
        
        let cgImage = image.cgImage!
        
          var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                              bitsPerPixel: 32,
                                              colorSpace: nil,
                                              bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                              version: 0,
                                              decode: nil,
                                              renderingIntent: CGColorRenderingIntent.defaultIntent)
          
            var sourceBuffer = vImage_Buffer()
              defer { free(sourceBuffer.data) }
              var error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                                          &format,
                                                          nil,
                                                          cgImage,
                                                          numericCast(kvImageNoFlags))
           guard error == kvImageNoError else { return nil }
          
           var intermediateBuffer = vImage_Buffer()
         defer { free(intermediateBuffer.data) }
             error =  vImageBuffer_Init(&intermediateBuffer,
                                        vImagePixelCount(Int(sourceBuffer.height)),
                                        vImagePixelCount(Int(sourceBuffer.width)),
                                              format.bitsPerPixel,
                                              vImage_Flags(kvImageNoFlags))
           guard error == kvImageNoError else { return nil }
          
           var destinationBuffer = vImage_Buffer()
         defer { free(destinationBuffer.data) }
            error = vImageBuffer_Init(&destinationBuffer,
                                      vImagePixelCount(Int(sourceBuffer.height)),
                                      vImagePixelCount(Int(sourceBuffer.width)),
                                    format.bitsPerPixel,
                                    vImage_Flags(kvImageNoFlags))

            guard error == kvImageNoError else { return nil }
          
         
            let resamplingFilter: ResamplingFilter
            
          
            if linear {
                // A linear interpolation resampling function. The
                // `inPointer` contains a series of pixel distances
                // from the current pixel. The function writes a set
                // of kernel weights to `outPointer`.
                func kernelFunc(inPointer: UnsafePointer<Float>?,
                                outPointer: UnsafeMutablePointer<Float>?,
                                count: UInt,
                                userData: UnsafeMutableRawPointer?) {
                    if let inPointer = inPointer, let outPointer = outPointer {
                        let absolutePixelPositions =
                            Array(UnsafeBufferPointer(start: inPointer,
                                                      count: Int(count))).map {
                                                        abs($0)
                            }

                        let kernelValues = absolutePixelPositions.map {
                            (absolutePixelPositions.max()! - $0)
                        }
                        
                        let normalizedKernelValues = kernelValues.map {
                            $0 / kernelValues.reduce(0, +)
                        }
                        
                        outPointer.assign(from: normalizedKernelValues,
                                          count: Int(count))
                    }
                }
                
                // Given a specified kernel width, calculate and allocate
                // the memory required for the resampling filter.
                let kernelWidth: Float = 1.5
                
              let size = vImageGetResamplingFilterSize(scale,
                                                         kernelFunc,
                                                         kernelWidth,
                                                         vImage_Flags(kvImageNoFlags))
                
                resamplingFilter = ResamplingFilter.allocate(byteCount: size,
                                                             alignment: 1)
                
                // Populate `resamplingFilter` with the custom linear
                // resampling filter.
                vImageNewResamplingFilterForFunctionUsingBuffer(resamplingFilter,
                                                                scale,
                                                                kernelFunc,
                                                                kernelWidth,
                                                                nil,
                                                                vImage_Flags(kvImageNoFlags))
            } else {
              
                
                // Create a high-quality Lanczos resampling filter.
              resamplingFilter = vImageNewResamplingFilter(scale,
                                              vImage_Flags(kvImageHighQualityResampling))
                
            }
            // Perform a 2D scale about the center of the buffer in two separate passes.
            var backColor = UInt8(0)
          let height = Float(sourceBuffer.height)
          let width = Float(sourceBuffer.width)
          let xTranslate = (width - width * scale) * 0.5
          let yTranslate = (height - height * scale) * 0.5
            vImageVerticalShear_ARGB8888(&sourceBuffer,
                                         &intermediateBuffer,
                                          0, 0,
                                         yTranslate,
                                         0,
                                         resamplingFilter,
                                         &backColor,
                                         vImage_Flags(kvImageNoFlags))
       
            
            vImageHorizontalShear_ARGB8888(&intermediateBuffer,
                                           &destinationBuffer,
                                           0, 0,
                                           xTranslate,
                                           0,
                                           resamplingFilter,
                                           &backColor,
                                           vImage_Flags(kvImageNoFlags))
            // Release the resampling filter using correct approach for type.
            if linear  {
                resamplingFilter.deallocate()
            } else {
                vImageDestroyResamplingFilter(resamplingFilter)
            }
          
          
            guard let scaledContent = vImageCreateCGImageFromBuffer(&destinationBuffer,
                                                                       &format,
                                                                       nil,
                                                                       nil,
                                                                  numericCast(kvImageNoFlags),
                                                                  &error)?.takeRetainedValue()
                   ,error == kvImageNoError
                   else { return nil }
            
             return UIImage(cgImage: scaledContent)
        }
    
      
    
}
