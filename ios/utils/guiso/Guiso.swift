//
//  Guiso.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit
import Photos
class Guiso {
    
    static private var instance : Guiso?
    private var mMemoryCache = LRUCache<UIImage>(25)
    private var mExecutor = Executor("Guiso")
    private var mDiskCache = DiskCache("Guiso")
    private var mMemoryCacheGif = LRUCacheGif(10)
    private var mAssets = [PHAsset]()
    private init() {}
    
    public static func load(_ url: String) -> GuisoRequestBuilder{
         return GuisoRequestBuilder(url)
    }
    
    static func get() -> Guiso {
        if instance == nil {
            instance = Guiso()
        }
        return instance!
    }
    
    
    func getAssets() -> [PHAsset]{
        if mAssets.isEmpty {
            mAssets = ImageHelper.allAssets()
        }
        return mAssets
    }
    
    func putLoad(_ request:GuisoRequestBuilder,_ target: ViewTarget){
        let work = GuisoRequest(request,target)
        mExecutor.doWork(work)
        
    }
    
    func cleanMemoryCache(){
        mMemoryCache.clear()
    }
    
    func cleanDiskCache(){
        mExecutor.doWork { [weak self] in
            self?.mDiskCache.clean()
        }
    }
    
    func getMemoryCache() -> LRUCache<UIImage> {
        return mMemoryCache
    }
    func getMemoryCacheGif() -> LRUCacheGif {
        return mMemoryCacheGif
    }
    
    func getDiskCache() -> DiskCache {
        return mDiskCache
    }
    
    enum DiskCacheStrategy {
        case none,
        all,
        data,
        resource,
        automatic
    }
    
    enum MediaType {
        case image,
        video,
        gif,
        audio
    }
    
    enum ScaleType {
        case fitCenter,
        centerCrop,
        fill,
        none
    }
   
}
