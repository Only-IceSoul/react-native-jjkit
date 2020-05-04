//
//  FileCache.swift
//  
//
//  Created by Juan J LF on 4/23/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit
import MobileCoreServices

class DiskCache {
    

    
    private var mDirectory : URL!
    private var mLock = NSLock()
    
    init(_ folder: String) {
        let cacheFolder = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        mDirectory = URL(fileURLWithPath: cacheFolder).appendingPathComponent(folder)
        createDirectory(mDirectory.path)
     
    }
    
    func getDirectory() -> URL {
        return mDirectory
    }
    
    @discardableResult
    private func createDirectory(_ pathString:String) -> Bool{
        if !FileManager.default.fileExists(atPath: pathString) {
            do {
                try FileManager.default.createDirectory(atPath: pathString, withIntermediateDirectories: true, attributes: nil)
                print("directory created : " ,pathString)
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
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do{
                let d = try Data(contentsOf: fileUrl)
                return d
            }catch let e {
                print("DiskCache:error - get -> ",e)
                return nil
            }
        }
        return nil
    }
    
    @discardableResult
    func add(_ key:String, data : Data) -> Bool {
        objc_sync_enter(mLock) ; defer { objc_sync_exit(mLock) }
        
        if key.isEmpty { return false }
         if !createDirectory(mDirectory.path) { return false }
        let fileUrl = mDirectory.appendingPathComponent(key)
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
        
            do {
                try data.write(to: fileUrl,options: .atomic)
                return true
            } catch {
                print("error saving file with key : \(key)  -> ", error)
                return false
            }
        }
        return true
    }
    
    @discardableResult
    func addGif(_ key:String, images: [CGImage],delays: [Double],loopCount: Int = 0) -> Bool{
        if images.isEmpty || delays.isEmpty  ||  images.count != delays.count {
            print("DiskCache:error - addGif not size array not are equals or is empty")
            return false
        }
        objc_sync_enter(mLock) ; defer { objc_sync_exit(mLock) }

        if key.isEmpty { return false }
        if !createDirectory(mDirectory.path) { return false }

        let fileUrl = mDirectory.appendingPathComponent(key)

        let destinationGIF = CGImageDestinationCreateWithURL(fileUrl as CFURL,
                                                             kUTTypeGIF,
                                                             images.count,
                                                             nil)!

        let loopProperty = [
                          (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFLoopCount as String): NSNumber(integerLiteral: loopCount),
                                (kCGImagePropertyGIFHasGlobalColorMap as String): false as NSNumber
                        ]
                      ]
        
        CGImageDestinationSetProperties(destinationGIF,loopProperty as CFDictionary?)
    

        for (index, img)  in images.enumerated() {
            let colorMap = img.getColorMap()
            // This dictionary controls the delay between frames
            // If you don't specify this, CGImage will apply a default delay
            let imageProperty = [
                (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): delays[index],
                    String(kCGImagePropertyGIFImageColorMap): colorMap.exported as NSData
                ]
            ]
            
           // Add the frame to the GIF image
           CGImageDestinationAddImage(destinationGIF, img, imageProperty as CFDictionary?)
        }

      
        // Write the GIF file to disk
       let result = CGImageDestinationFinalize(destinationGIF)
        
        return result
    }
    
    
    func clean(){
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: mDirectory.path) {
                try fileManager.removeItem(atPath: mDirectory.path)
            } else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place cleaning disk cache: \(error)")
        }
    }
    
}
