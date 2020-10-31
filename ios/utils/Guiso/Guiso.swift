//
//  Guiso.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit
import Photos
public class Guiso {
    
    static private var instance : Guiso?
    private var mMemoryCache = GuisoCache(200)
    private var mExecutor = Executor("Guiso")
    private var mDiskCache = GuisoDiskCache("Guiso", maxSize: 250)
    private var mMemoryCacheGif = GuisoCacheGif(50)
    private var mLock = NSLock()
    private init() {}
    
  
    public static func load(model: Any?) -> GuisoRequestBuilder{
        return GuisoRequestBuilder(model:model)
    }
    public static func load(model:Any?,loader: LoaderProtocol) -> GuisoRequestBuilder{
           return GuisoRequestBuilder(model: model, loader: loader)
    }
    
    static public func get() -> Guiso {
        if instance == nil {
            instance = Guiso()
        }
        return instance!
    }
    
    func getExecutor() -> Executor {
        return mExecutor
    }

    func getAsset(_ id:String) -> PHFetchResult<PHAsset> {
         let options = PHFetchOptions()
         options.predicate = NSPredicate(format: "localIdentifier == %@",id)
         return PHAsset.fetchAssets(with: options)
     }
    
    public func cleanMemoryCache(){
        mMemoryCache.clear()
        mMemoryCacheGif.clear()
    }
    
    public func clear(target:ViewTarget?){
        if target == nil { return }
        GuisoRequestManager.clear(target: target!)
    }
    
    public func cleanDiskCache(){
        mExecutor.doWork {
            self.mDiskCache.clean()
        }
    }
    
    func getMemoryCache() -> GuisoCache {
        return mMemoryCache
    }
    func getMemoryCacheGif() -> GuisoCacheGif {
        return mMemoryCacheGif
    }
  
    
    func getDiskCache() -> GuisoDiskCache {
        return mDiskCache
    }
  
    
    public enum DiskCacheStrategy {
        case none,
        all,
        data,
        resource,
        automatic
    }
    
    public enum MediaType {
        case image,
        video,
        gif,
        audio
    }
    
    public enum AnimatedType :Int  {
        case gif = 0,
        webp
    }
    
    
    public enum ScaleType:Int {
        case fitCenter = 0,
        centerCrop,
        none
    }
   
    public enum Priority :Int {
        case background = 0,
        low,
        normal,
        high
    }
    
    public enum LoadType  :Int {
         case data = 0,
         uiimg,
         animatedImg
      }
    
    public enum DataSource  :Int {
        case local = 0,
             remote,
             memoryCache,
             dataDiskCache,
             resourceDiskCache
    }
      
    
    func writeToCacheFolder(_ data:Data,name:String) -> URL? {
            mLock.lock(); defer { mLock.unlock() }
        do{
            let cacheDir = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
            let path = URL(fileURLWithPath: cacheDir).appendingPathComponent(name)
            try data.write(to: path)
            return path

        }catch let error as NSError {
            print("writeToCacheFolder - dataVideo  -> Image generation -  failed with error: \(error)")
            return nil
        }
    }
}
