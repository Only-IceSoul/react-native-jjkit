//
//  GuisoSaver.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit
import CoreServices

class GuisoSaver {
    

    
    static func saveToMemoryCache(key:Key,image:UIImage?){
          if image == nil { return  }
           let cache = Guiso.get().getMemoryCache()
        cache.add(key, val: image!)
      }
      
    static func saveToMemoryCache(key: Key,gif:AnimatedImage?){
         if gif == nil  { return  }
         let cache = Guiso.get().getMemoryCacheGif()
        cache.add(key, val: gif!)
      }
      
    static func saveToDiskCache(key:Key,image:UIImage?){
        if image?.cgImage == nil { return  }
        let diskCache = Guiso.get().getDiskCache()
        if let data = makeImageData(image!){
              diskCache.add(key, data: data,isUpdate: false)
        }
        
    }

    static func saveToDiskCache(key:Key,gif:AnimatedImage?){
        if gif == nil { return  }
        let diskCache = Guiso.get().getDiskCache()
        diskCache.add(key, classObj: gif!,isUpdate: false)
            
    }
    
  
    

    private static func makeImageData(_ img:UIImage, format: String) -> Data? {
        switch format {
            case "PNG","png":
              return img.pngData()
            default:
             return img.jpegData(compressionQuality: 1)
        }
    }
    
    
    private static func makeImageData(_ img:UIImage)-> Data?{
        let alpha = img.cgImage!.alphaInfo
            let hasAlpha = alpha == CGImageAlphaInfo.first ||
                    alpha == CGImageAlphaInfo.last ||
                    alpha == CGImageAlphaInfo.premultipliedFirst ||
                alpha == CGImageAlphaInfo.premultipliedFirst
        
        if hasAlpha {
            return img.pngData()
        }else{
            return img.jpegData(compressionQuality: 0.9)
        }
                    
    }
}
