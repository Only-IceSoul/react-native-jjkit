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
    private var mDiskCache = LRUDiskCache("Guiso", maxSize: 50)
    private var mMemoryCacheGif = LRUCacheGif(10)
    private var mAssets = [PHAsset]()
    private init() {}

    public static func load(_ url: String) -> GuisoRequestBuilder{
        return GuisoRequestBuilder(url)
    }

    public static func load(_ url: String,header:GuisoHeader) -> GuisoRequestBuilder{
       return GuisoRequestBuilder(url, header: header)
    }

    public static func load(_ url: URL) -> GuisoRequestBuilder{
       return GuisoRequestBuilder(url)
    }

    public static func load(_ url: URL,header:GuisoHeader) -> GuisoRequestBuilder{
      return GuisoRequestBuilder(url, header: header)
    }
        

    public static func load(_ data: Data) -> GuisoRequestBuilder{
        return GuisoRequestBuilder(data)
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
       if mAssets.isEmpty {
           mAssets = ImageHelper.allAssets()
       }
       return mAssets
    }

    func putLoad(_ request:GuisoRequestBuilder,_ target: ViewTarget,_ priority: Guiso.Priority){
       let work = GuisoRequest(request,target)
       let p = getPriority(priority)
       mExecutor.doWork(work,priority: p , flags: .enforceQoS )
       
    }

    public func cleanMemoryCache(){
       mMemoryCache.clear()
       mMemoryCacheGif.clear()
    }

    public func cleanDiskCache(){
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

    func getDiskCache() -> LRUDiskCache {
       return mDiskCache
    }

    private func getPriority(_ priority:Guiso.Priority) -> DispatchQoS {
       switch priority {
       case .low:
           return .background
       case .immediate:
           return .userInteractive
       case .high:
           return .userInitiated
       default:
           return .utility
       }
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
       case low,
       normal,
       high,
       immediate
    }
  
}
