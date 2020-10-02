//
//  GuisoSaver.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit
import CoreServices

class GuisoSaver {
    

    
    func saveToMemoryCache(key:String,image:UIImage?){
          if image == nil { return  }
           let cache = Guiso.get().getMemoryCache()
           cache.add(key, val: image!,isUpdate: false)
      }
      
    func saveToMemoryCache(key: String,gif:Gif?){
         if gif == nil  { return  }
         let cache = Guiso.get().getMemoryCacheGif()
          cache.add(key, val: gif!,isUpdate: false)
      }
      
    func saveToDiskCache(key:String,image:UIImage?){
        if image?.cgImage == nil { return  }
        let diskCache = Guiso.get().getDiskCache()
        if let data = makeImageData(image!){
              diskCache.add(key, data: data,isUpdate: false)
        }
        
    }

    func saveToDiskCache(key:String,gif:Gif?){
        if gif == nil { return  }
        let diskCache = Guiso.get().getDiskCacheObject()
        diskCache.add(key, obj: gif!,isUpdate: false)
            
    }
    
  
    

    private func makeImageData(_ img:UIImage, format: String) -> Data? {
        switch format {
            case "PNG","png":
              return img.pngData()
            default:
             return img.jpegData(compressionQuality: 1)
        }
    }
    
    
    private func makeImageData(_ img:UIImage)-> Data?{
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
