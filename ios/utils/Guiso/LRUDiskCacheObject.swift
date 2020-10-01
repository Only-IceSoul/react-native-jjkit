//
//  LRUDiskCacheObject.swift
//  Guiso
//
//  Created by Juan J LF on 5/20/20.
//


import UIKit
import MobileCoreServices

class LRUDiskCacheObject {
    
    private var  mKeySize = "GuisoDiskCacheObjectSize"
    private var mDirectory : URL!
    private var mLock = NSLock()
    private var mMaxSize: Double = 0
    private var mCurrentSize : Double = 0
    private var mPriority: LinkedList<String> = LinkedList<String>()
    private var mKey2node: [String: LinkedList<String>.LinkedListNode<String>] = [:]
    init(_ folder: String, maxSize:Double) {
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
    
    

    func get(_ key:String) -> Any? {
        mLock.lock() ; defer { mLock.unlock() }
        if key.isEmpty { return nil }
        if !createDirectory(mDirectory.path) { return nil }
        let fileUrl = mDirectory.appendingPathComponent(key)
        guard let data = getData(url: fileUrl),
          let obj = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
          else { return nil }
          updateKey(key: key)
          return obj
    }
    
    open func getSizeObject(data: Data?) -> Double {
          let bytes  = data?.count ?? 0
          return Double(bytes) / 1048576
    }
    
    @discardableResult
    func add(_ key:String, obj : Any ,isUpdate: Bool = true) -> Bool {
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
           result = addObject(url: fileUrl, object: obj)
           if result { insertKey(key) }
       }
       
       return result
    }

    private func addObject(url: URL,object:Any) -> Bool{
        do {
            let data = NSKeyedArchiver.archivedData(withRootObject: object)
            try data.write(to: url)
            sumCurrentSize(data: data)
            return true
        } catch {
            print("Couldn't write file")
            return false
        }
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
