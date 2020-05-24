//
//  GuisoSaver.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit


class GuisoSaver {
    
    private var mStrategy = Guiso.DiskCacheStrategy.automatic
    private var mFormat = "png"
    private var mSkipMemory = false
    init(_ st:Guiso.DiskCacheStrategy,format:String,skipMemory:Bool) {
        mStrategy = st
        mFormat = format
        mSkipMemory = skipMemory
    }
    
    func setStrategy(_ st:Guiso.DiskCacheStrategy){
        mStrategy = st
    }
    
    func saveToMemoryCache(key:String,image:UIImage?){
          if image == nil || mSkipMemory { return  }
           let cache = Guiso.get().getMemoryCache()
           cache.add(key, val: image!,isUpdate: false)
      }
      
    func saveToMemoryCache(key: String,gif:Gif?){
         if gif == nil || mSkipMemory  { return  }
         let cache = Guiso.get().getMemoryCacheGif()
          cache.add(key, val: gif!,isUpdate: false)
      }
      
    func saveToDiskCache(key:String,image:UIImage?){
        if image == nil { return  }
          //manage strategys
          let diskCache = Guiso.get().getDiskCache()
          if mStrategy == .automatic {
            if let data = makeImageData(image!, format: mFormat){
                  diskCache.add(key, data: data,isUpdate: false)
            }
          }
      }

    func saveToDiskCache(key:String,gif:Gif?){
        if gif == nil { return  }
        //manage strategys
            let diskCache = Guiso.get().getDiskCacheObject()
            if mStrategy == .automatic {
                diskCache.add(key, obj: gif!,isUpdate: false)
            }
    }
    
    func saveToDiskCache(key:String,data:Data){
     //manage strategys
         let diskCache = Guiso.get().getDiskCache()
         if mStrategy == .automatic {
             diskCache.add(key, data: data,isUpdate: false)
         }
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
