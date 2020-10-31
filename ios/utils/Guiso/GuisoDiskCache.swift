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

class GuisoDiskCache {
    
    private var  mKeySize = "GuisoDiskCacheSize"

    private var mDirectory : URL!
    private var mLock = pthread_rwlock_t()
    private var mMaxSize: Int = 0
   
    private var mKeyGenerator = KeyGenerator()
 

    init(_ folder: String, maxSize:Int,cleanInBg:Bool = false) {
        pthread_rwlock_init(&mLock, nil)
//        let cacheFolder = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        mDirectory = document.appendingPathComponent(folder)
        createDirectory(mDirectory.path)
        mMaxSize = maxSize * 1048576

      
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        
        if cleanInBg {
            NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        }
        
        
  
    }
    deinit {
        pthread_rwlock_destroy(&mLock)
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
    
    
    func get(_ key:Key) -> Data? {
        pthread_rwlock_rdlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
        
        if !createDirectory(mDirectory.path) { return nil }
        guard let strKey = mKeyGenerator.getKeyString(key: key) else { return nil }
        let fileUrl = mDirectory.appendingPathComponent(strKey)
        let data = getData(url: fileUrl)

        return data
    }
    
    func getClassObj(_ key:Key) -> AnyObject? {
        pthread_rwlock_rdlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
        if !createDirectory(mDirectory.path) { return nil }
        guard let strKey = mKeyGenerator.getKeyString(key: key) else { return nil }
        let fileUrl = mDirectory.appendingPathComponent(strKey)
        let obj = getObject(url: fileUrl)
       
        return obj
    }
 
  
    
    @discardableResult
    func add(_ key:Key, data : Data,isUpdate: Bool = false) -> Bool {
        return addItem(key,data,isUpdate,isClassObj: false)
    }
    
    @discardableResult
    func add(_ key:Key, classObj : AnyObject,isUpdate: Bool = false) -> Bool {
        return addItem(key,classObj,isUpdate,isClassObj: true)
    }
    
    private func addItem(_ key:Key,_ obj:Any,_ isUpdate:Bool,isClassObj:Bool) -> Bool{
        pthread_rwlock_wrlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
         if !createDirectory(mDirectory.path) { return false }
        guard let strKey = mKeyGenerator.getKeyString(key: key) else { return false }
        let fileUrl = mDirectory.appendingPathComponent(strKey)
        var needAdd = false
        let item = getData(url: fileUrl)

        if item == nil  {
          needAdd = true
        }
        if item != nil && isUpdate {
             remove(url: fileUrl)
             needAdd = true
        }
              
        var result = true
        if needAdd {
            if isClassObj{
                result = addObject(url: fileUrl, object: obj)
            }else {
                result = addData(url: fileUrl, data: obj as! Data)
            }
         
        
        }
        
        return result
    }

    
    private func addData(url:URL,data:Data) -> Bool{
        if !FileManager.default.fileExists(atPath: url.path) {
           do {
            try data.write(to: url,options: .atomic)
               return true
           } catch {
               print("error saving file  -> ", error)
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
    
    private func addObject(url: URL,object:Any) -> Bool{
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                 let data =  NSKeyedArchiver.archivedData(withRootObject: object)
                try data.write(to: url)
                return true
            } catch {
                print("Couldn't write file")
                return false
            }
        }
        return true
    }
    
    private func getObject(url:URL) -> AnyObject?{
        guard let data = getData(url: url),
            let obj = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            else { return nil}

        return obj as AnyObject
    }
    
    @discardableResult
    private func remove(url:URL) -> Bool {
        if FileManager.default.fileExists(atPath: url.path) {
          do {
             try FileManager.default.removeItem(at: url)
              return true
          } catch {
              print("error removing file  -> ", error)
              return false
          }
        }
        return true
    }
    
    @discardableResult
    private func remove(file:File) -> Bool {
        guard let url = file.url else { return false }
        if FileManager.default.fileExists(atPath: url.path) {
          do {
              try FileManager.default.removeItem(at: url)
              return true
          } catch {
              print("error removing file  -> ", error)
              return false
          }
        }
        return true
    }
    
   
    
    func clean(){
        pthread_rwlock_wrlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: mDirectory.path) {
                try fileManager.removeItem(atPath: mDirectory.path)
                print("Cleaned - Guiso")
            } else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place cleaning disk cache: \(error)")
        }
    }
    
 
    private func bytesToMb(bytes:Int)->Double{
        return Double(bytes) / 1048576.0
    }
    
  

    open func getSizeObject(data: Data?) -> Double {
          let bytes  = data?.count ?? 0
          return bytesToMb(bytes: bytes)
    }
    
    private var mIsDeletingCancelled = false
    private func deleteExpiredData(){
        pthread_rwlock_wrlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
        
        if mIsDeletingCancelled { return }
        let resourceKeys = [URLResourceKey.fileAllocatedSizeKey,URLResourceKey.contentModificationDateKey]
        if let fileEnum = FileManager.default.enumerator(at: mDirectory, includingPropertiesForKeys: resourceKeys, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles){
        
            if mIsDeletingCancelled { return }
       
    
        var arr = [File]()
        var currentSize = 0
        for case let url as URL in fileEnum {
            if mIsDeletingCancelled { break }
                do{
                     let re = try url.resourceValues(forKeys: Set(resourceKeys))
                    if mIsDeletingCancelled { break }
                    if let md = re.contentModificationDate , let size = re.fileAllocatedSize{
                        arr.append(File(url: url, modificationDate: md, allocateSize: size))
                        currentSize += size
                    }
                }catch (let e ){
                    print("error resolve \(e)")
                }
            }
            
            if mIsDeletingCancelled  { return }
            
            let result = arr.sorted { (a, d) -> Bool in
                return a.modificationDate! < d.modificationDate!
            }
            
            if mIsDeletingCancelled  { return }
            for it in result {
                if remove(file: it) {
                    currentSize -= it.allocateSize!
                }
                
                if currentSize <= (mMaxSize * 70) / 100{
                    break
                }
                if mIsDeletingCancelled { break }
            }
            
        }else{
            print("fileenum is nil")
        }
    
        
    }
    
    
    @objc func appWillEnterForeground(notification:Notification){
        mIsDeletingCancelled = true
    }
    private var mBgTaskID = UIBackgroundTaskIdentifier.invalid
    @objc func appDidEnterBackground(notification:Notification){

        mBgTaskID =  UIApplication.shared.beginBackgroundTask {

            print("releasing bg task")
            UIApplication.shared.endBackgroundTask(self.mBgTaskID)
            self.mBgTaskID = .invalid
        }
        
        self.mIsDeletingCancelled = false

        Guiso.get().getExecutor().doWork {
           self.deleteExpiredData()
            UIApplication.shared.endBackgroundTask(self.mBgTaskID)
            self.mBgTaskID = .invalid
        }

    }

    
    @objc func appWillTerminate(notification:Notification){
    
        let sm =  DispatchSemaphore(value: 0)
        self.mIsDeletingCancelled = true
        Guiso.get().getExecutor().doWork {
            self.deleteExpiredDataShort()
            sm.signal()
        }

        sm.wait()
        
    }
  
    

    private func deleteExpiredDataShort(){
        
        let startTime = DispatchTime.now()
        
        let resourceKeys = [URLResourceKey.fileAllocatedSizeKey,URLResourceKey.contentModificationDateKey]
        if let fileEnum = FileManager.default.enumerator(at: mDirectory, includingPropertiesForKeys: resourceKeys, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles){
            
    
        var arr = [File]()
        var currentSize = 0
        for case let url as URL in fileEnum {
   
                do{
                     let re = try url.resourceValues(forKeys: Set(resourceKeys))
                    if let md = re.contentModificationDate , let size = re.fileAllocatedSize{
                        arr.append(File(url: url, modificationDate: md, allocateSize: size))
                        currentSize += size
                    }
                }catch (let e ){
                    print("error resolve \(e)")
                }
            }
     
        
            let result = arr.sorted { (a, d) -> Bool in
                return a.modificationDate! < d.modificationDate!
            }
      
            for it in result {
                let time =  DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds
                if (Double(time) / 1_000_000_000) > 2.5{ break }
                if remove(file: it) {
                    currentSize -= it.allocateSize!
                }
                
                if currentSize <= (mMaxSize * 70) / 100{
                    break
                }
           
            }
            
        }else{
            print("fileenum is nil short")
        }
    }
}
