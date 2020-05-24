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
    private var mMemoryCache = LRUCache<UIImage>(25)
    private var mExecutor = Executor("Guiso")
    private var mDiskCache = LRUDiskCache("Guiso", maxSize: 50)
    private var mDiskCacheObject = LRUDiskCacheObject("Guiso", maxSize: 20)
    private var mMemoryCacheGif = LRUCacheGif(10)
    private var mAssets = [PHAsset]()
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
    
    func getAssets() -> [PHAsset]{
        mLock.lock() ; defer { mLock.unlock() }
        if mAssets.isEmpty {
            mAssets = allAssets()
        }
        return mAssets
    }
    
    private func allAssets()-> [PHAsset]{
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        var array = [PHAsset]()
        if smartAlbums.count > 0 {
            for i in 0...(smartAlbums.count-1){
               let a = smartAlbums.object(at: i)
               let assets = getAssets(fromCollection: a )
                if assets.count > 0 {
                    for sii in 0...(assets.count-1){
                        array.append(assets.object(at: sii))
                    }
                }
            }
        }
        
        if userCollections.count > 0 {
           for i in 0...(userCollections.count-1){
              let c = userCollections.object(at: i)
            let assets = getAssets(fromCollection: c as! PHAssetCollection )
               if assets.count > 0 {
                   for ci in 0...(assets.count-1){
                       array.append(assets.object(at: ci))
                   }
               }
           }
        }
        return array
    }
    
    private func getAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d",
        PHAssetMediaType.image.rawValue,
        PHAssetMediaType.video.rawValue)
        return PHAsset.fetchAssets(in: collection, options: options)
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
         uiimg
      }
      
}
