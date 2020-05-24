//
//  LRUCache.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit
import Foundation

 class LRUCache<T: AnyObject>{
  private var mMaxSize: Double
  private var mCurrentSize : Double = 0
  private var mCache  = NSCache<NSString,T>()
  private var mPriority: LinkedList<String> = LinkedList<String>()
  private var mKey2node: [String: LinkedList<String>.LinkedListNode<String>] = [:]
  private let mLock = NSLock()
  public init(_ maxSize: Double) {
    self.mMaxSize = maxSize <= 4 ? 5 : maxSize
    
  }
    
     func setMaxSize(_ maxSize: Double){
        self.mMaxSize = maxSize
    }
  
   func get(_ key: String) -> T? {
     mLock.lock(); defer { mLock.unlock() }
    guard let val = mCache.object(forKey: key as NSString) else  { return nil }
    
    remove(key)
    insert(key, val: val)
    
    return val
  }

     func add(_ key: String, val: T, isUpdate: Bool = true) {
        objc_sync_enter(mLock); defer { objc_sync_exit(mLock) }
   
            if key.isEmpty { return  }
        var needAdd = false
        let item = mCache.object(forKey: key as NSString)
        
        if item == nil  {
           needAdd = true
        }
        if item != nil && isUpdate {
             self.mCurrentSize -= self.getSizeObject(obj: item!)
              remove(key)
              needAdd = true
        }
       
        
        if needAdd {
            if mCurrentSize >= mMaxSize, let keyToRemove = mPriority.last?.value {
                if let obj = mCache.object(forKey: keyToRemove as NSString) {
                    self.mCurrentSize -= getSizeObject(obj: obj )
                }
                remove(keyToRemove)
            }
            self.mCurrentSize += getSizeObject(obj: val)
            insert(key, val: val)
        }
    }
    
    
    open func getSizeObject(obj: T) -> Double {
        var result: Double = 1
        if let img = obj as? UIImage {
                result = Double(img.cgImage!.bytesPerRow * img.cgImage!.height) / 1048576
        }
    
        return result
    }
    
    func clear(){
        mCache.removeAllObjects()
        mPriority.removeAll()
        mKey2node.removeAll()
        mCurrentSize = 0
    }
    func size()-> Double {
        return self.mCurrentSize
    }
  
  private func remove(_ key: String) {
    mCache.removeObject(forKey: key as NSString)
    guard let node = mKey2node[key] else {
      return
    }
    mPriority.remove(node: node)
    mKey2node.removeValue(forKey: key)
  }
  
    private func insert(_ key: String, val: T) {
        mCache.setObject(val, forKey: key as NSString)
        mPriority.insert(key, atIndex: 0)
        guard let first = mPriority.first else {return}
        mKey2node[key] = first
    }
}
