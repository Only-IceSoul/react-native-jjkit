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
    private var mMemoryCache = LRUCache<UIImage>(30)
    private var mExecutor = Executor("Guiso")
    private var mDiskCache = LRUDiskCache("Guiso", maxSize: 100)
    private var mDiskCacheObject = LRUDiskCacheObject("Guiso", maxSize: 100)
    private var mMemoryCacheGif = LRUCacheGif(13)
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
    
    public func cleanDiskCache(){
        mExecutor.doWork {
            self.mDiskCache.clean()
            self.mDiskCacheObject.clean()
        }
    }
    
    func getMemoryCache() -> LRUCache<UIImage> {
        return mMemoryCache
    }
    func getMemoryCacheGif() -> LRUCacheGif {
        return mMemoryCacheGif
    }
    func getDiskCacheObject() -> LRUDiskCacheObject {
        return mDiskCacheObject
    }
    
    func getDiskCache() -> LRUDiskCache {
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
    
    public enum ScaleType {
        case fitCenter,
        centerCrop,
        none
    }
   
    public enum Priority {
        case background,
        low,
        normal,
        high
    }
    
    public enum LoadType {
         case data,
         uiimg,
         gif
      }
    
    public enum DataSource {
        case local,
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
