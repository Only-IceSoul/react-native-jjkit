//
//  FileCache.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/23/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit
import MobileCoreServices
import ImageIO

class LRUDiskCache {
    
    private var  mKeySize = "GuisoDiskCacheSize"
    private var mDirectory : URL!
    private var mLock = NSLock()
    private var mMaxSize: Double = 0
    private var mCurrentSize : Double = 0
    private var mPriority: LinkedList<String> = LinkedList<String>()
    private var mKey2node: [String: LinkedList<String>.LinkedListNode<String>] = [:]
    init(_ folder: String, maxSize:Double) {
//        let cacheFolder = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        mDirectory = document.appendingPathComponent(folder)
        createDirectory(mDirectory.path)
        mMaxSize = maxSize
        mCurrentSize = UserDefaults.standard.double(forKey: mKeySize)
     
    }
    
    func getDirectory() -> URL {
        return mDirectory
    }
    
    @discardableResult
    private func createDirectory(_ pathString:String) -> Bool{
        if !FileManager.default.fileExists(atPath: pathString) {
            do {
                try FileManager.default.createDirectory(atPath: pathString, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                print("DiskCache:error - createDirectory -> ",error.localizedDescription);
                return false
            }
        }
        return true
    }
    
    
    func get(_ key:String) -> Data? {
        mLock.lock() ; defer { mLock.unlock() }
        if key.isEmpty { return nil }
        if !createDirectory(mDirectory.path) { return nil }
        let fileUrl = mDirectory.appendingPathComponent(key)
        let data = getData(url: fileUrl)
        if data != nil { updateKey(key: key) }
        return data
    }
    
 
    open func getSizeObject(data: Data?) -> Double {
          let bytes  = data?.count ?? 0
          return Double(bytes) / 1048576
    }
    
//    func addCGImage(_ key:String,img:UIImage){
//        let uri = mDirectory.appendingPathComponent(key)
//        let imgre = CGImageDestinationCreateWithURL(uri as CFURL, kUTTypePNG, 1, nil)
//        CGImageDestinationAddImage(imgre!,img.cgImage!,nil)
//        CGImageDestinationFinalize(imgre!)
//    }
    
    @discardableResult
    func add(_ key:String, data : Data,isUpdate: Bool = true) -> Bool {
        objc_sync_enter(mLock) ; defer { objc_sync_exit(mLock) }
        if key.isEmpty { return false }
         if !createDirectory(mDirectory.path) { return false }
        let fileUrl = mDirectory.appendingPathComponent(key)
        var needAdd = false
        let item = getData(url: fileUrl)

        if item == nil  {
          needAdd = true
        }
        if item != nil && isUpdate {
             removeData(url: fileUrl,data: item)
             removeKey(key)
             needAdd = true
        }
              
        var result = true
        if needAdd {
            if mCurrentSize >= mMaxSize,  let keyToRemove = mPriority.last?.value {
                let fileToRemove = mDirectory.appendingPathComponent(keyToRemove)
                let datar = getData(url: fileToRemove)
                removeData(url: fileToRemove,data:datar)
                removeKey(keyToRemove)
            }
            result = addData(url: fileUrl, data: data)
            if result { insertKey(key) }
        }
        
        return result
    }
    
   
    
    @discardableResult
    func addGif(_ key:String, images: [CGImage],delays: [Double],loopCount: Int = 0,isUpdate: Bool = true) -> Bool{
        if images.isEmpty || delays.isEmpty  ||  images.count != delays.count {
            print("DiskCache:error -  not are equals or is empty")
            return false
        }
        objc_sync_enter(mLock) ; defer { objc_sync_exit(mLock) }

        if key.isEmpty { return false }
        if !createDirectory(mDirectory.path) { return false }

        let fileUrl = mDirectory.appendingPathComponent(key)
        
        var needAdd = false
        let item = getData(url: fileUrl)

        if item == nil  {
         needAdd = true
        }
        if item != nil && isUpdate {
            removeData(url: fileUrl,data: item)
            removeKey(key)
            needAdd = true
        }
             
        var result = true
        if needAdd {
           if mCurrentSize >= mMaxSize,  let keyToRemove = mPriority.last?.value {
               let fileToRemove = mDirectory.appendingPathComponent(keyToRemove)
               let datar = getData(url: fileToRemove)
               removeData(url: fileToRemove,data:datar)
               removeKey(keyToRemove)
           }
           
           result = saveGif(url: fileUrl, images: images, delays: delays, loopCount: loopCount)
           if result { insertKey(key) }
        }

        return result
    }
    
    
    private func saveGif(url:URL, images: [CGImage],delays: [Double],loopCount: Int = 0)-> Bool{
        let destinationGIF = CGImageDestinationCreateWithURL(url as CFURL,
                                                         kUTTypeGIF,
                                                         images.count,
                                                         nil)!

        let gifProperty = [
            
        (kCGImagePropertyGIFLoopCount as String): NSNumber(integerLiteral: loopCount),
                (kCGImagePropertyGIFHasGlobalColorMap as String): false as NSNumber
        ]

        CGImageDestinationSetProperties(destinationGIF,gifProperty as CFDictionary?)


        for (index, img)  in images.enumerated() {
        let colorMap = img.getColorMap()
        // This dictionary controls the delay between frames
        // If you don't specify this, CGImage will apply a default delay
        let imgProperty = [
            (kCGImagePropertyGIFDictionary as String): [
                (kCGImagePropertyGIFDelayTime as String): delays[index]
                ,
                String(kCGImagePropertyGIFImageColorMap): colorMap.exported as NSData
            ]
        ]

        // Add the frame to the GIF image
        CGImageDestinationAddImage(destinationGIF, img, imgProperty as CFDictionary?)
        }


        // Write the GIF file to disk
        let result = CGImageDestinationFinalize(destinationGIF)
        if result {
          let data = getData(url: url)
          sumCurrentSize(data: data)
        }
        return result
    }
    
    private func addData(url:URL,data:Data) -> Bool{
        if !FileManager.default.fileExists(atPath: url.path) {

           do {
               try data.write(to: url,options: .atomic)
                sumCurrentSize(data: data)
               return true
           } catch {
               print("error saving file  -> ", error)
               return false
           }
        }
        return true
    }
    
    @discardableResult
    private func removeData(url:URL,data:Data?) -> Bool {
        if FileManager.default.fileExists(atPath: url.path) {
          do {
              try FileManager.default.removeItem(at: url)
              subCurrentSize(data: data)
              return true
          } catch {
              print("error removing file  -> ", error)
              return false
          }
        }
        return true
    }
    
    private func getData(url: URL) -> Data? {
        if FileManager.default.fileExists(atPath: url.path) {
            do{
                let d = try Data(contentsOf: url)
                return d
            }catch let e {
                print("DiskCache:error - get -> ",e)
                return nil
            }
        }else{
            return nil
        }
    }
    
    private func sumCurrentSize(data:Data?){
         mCurrentSize += getSizeObject(data: data)
        UserDefaults.standard.set(mCurrentSize, forKey: mKeySize)
        
    }
    
    private func subCurrentSize(data:Data?){
          mCurrentSize -= getSizeObject(data: data)
        UserDefaults.standard.set(mCurrentSize, forKey: mKeySize)
     }
    
    func clean(){
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: mDirectory.path) {
                try fileManager.removeItem(atPath: mDirectory.path)
                resetCurrentSize()
                print("Cleaned - Guiso")
            } else {
                resetCurrentSize()
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place cleaning disk cache: \(error)")
        }
    }
    func resetCurrentSize(){
         UserDefaults.standard.set(0, forKey: mKeySize)
    }
    
    private func updateKey(key:String){
        if  removeKey(key){
            insertKey(key)
        }
    }
    
    @discardableResult
    private func removeKey(_ key:String)-> Bool{
        guard let node = mKey2node[key] else {
          return false
        }
        mPriority.remove(node: node)
        mKey2node.removeValue(forKey: key)
        return true
    }
    
    private func insertKey(_ key:String){
        mPriority.insert(key, atIndex: 0)
        guard let first = mPriority.first else {return}
        mKey2node[key] = first
    }
    
}
