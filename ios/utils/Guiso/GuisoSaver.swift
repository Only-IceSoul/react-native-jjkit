//
//  GuisoSaver.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit


class GuisoSaver {
    
    private var mFormat = "png"

    init(format:String) {
        mFormat = format
    }
    
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
        if image == nil { return  }
        let diskCache = Guiso.get().getDiskCache()
        if let data = makeImageData(image!, format: mFormat){
              diskCache.add(key, data: data,isUpdate: false)
        }
          
    }

    func saveToDiskCache(key:String,gif:Gif?){
        if gif == nil { return  }
        let diskCache = Guiso.get().getDiskCacheObject()
        diskCache.add(key, obj: gif!,isUpdate: false)
            
    }
    
    func saveToDiskCache(key:String,data:Data?){
        if data == nil { return }
        let diskCache = Guiso.get().getDiskCache()
        diskCache.add(key, data: data!,isUpdate: false)
         
     }
    

    private func makeImageData(_ img:UIImage, format: String) -> Data? {
        switch format {
            case "PNG","png":
              return img.pngData()
            default:
             return img.jpegData(compressionQuality: 1)
        }
    }
}
