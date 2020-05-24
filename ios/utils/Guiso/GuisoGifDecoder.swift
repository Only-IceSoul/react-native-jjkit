//
//  GifDecoder.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit

class GuisoGifDecoder: GifDecoderProtocol {

    
     func decode(data:Data) -> Gif? {
        
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("makeImageGif:error -> maybe not exist data or wrong data")
            return nil
        }
     
     
        let gif = Gif()
        let count = CGImageSourceGetCount(source)
         
         let cfProperties = CGImageSourceCopyProperties(source,nil)
         let gifProperties: CFDictionary = unsafeBitCast(
          CFDictionaryGetValue(cfProperties,
              Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
          to: CFDictionary.self)

         let loopCount: AnyObject? = unsafeBitCast(
          CFDictionaryGetValue(gifProperties,
              Unmanaged.passUnretained(kCGImagePropertyGIFLoopCount).toOpaque()),
          to: AnyObject.self)

         gif.loopCount = 0
         if let num = loopCount as? NSNumber {
           gif.loopCount = num.intValue
         }
           
        var images = [CGImage]()
        for i in 0..<count {
           if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
             images.append(image)
           }
           
           let delaySeconds = delayForImageAtIndex(Int(i),
               source: source)
           gif.delays.append(delaySeconds)
        }

         gif.frames = images
         let duration: Double = {
         var sum : Double = 0
          
         for val in gif.delays {
              sum += val
          }
          
          return sum
         }()

         gif.duration = duration

        return gif
     }
    
 
    
    private func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
         var delay = 0.1
         
         let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
         let gifProperties: CFDictionary = unsafeBitCast(
             CFDictionaryGetValue(cfProperties,
                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
             to: CFDictionary.self)
         
         var delayObject: AnyObject = unsafeBitCast(
             CFDictionaryGetValue(gifProperties,
                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
             to: AnyObject.self)

         if delayObject.doubleValue == 0 {
             delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                 Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
         }
          
          
         delay = delayObject as? Double ?? delay
        
         return delay
      }


}
