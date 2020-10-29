//
//  LRUCache.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit
import Foundation

class LRUCache<T: AnyObject> {
  private var mMaxSize: Int64 = 0
  private var mCurrentSize : Int64 = 0
  private var mCache  = [String:T]()
  private var mPriority: LinkedList<String> = LinkedList<String>()
  private var mKey2node: [String: LinkedList<String>.LinkedListNode<String>] = [:]
  private var mLock = pthread_rwlock_t()
  public init(_ maxSize: Double) {
 
    self.mMaxSize = maxSize < 1 ? mbToBytes(mb: 10) : mbToBytes(mb: maxSize)
    pthread_rwlock_init(&mLock, nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(appMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    
  }
    func mbToBytes(mb:Double)->Int64{
        return Int64(mb * 1048576.0)
    }
    
     func setMaxSize(_ maxSize: Double){
        self.mMaxSize = mbToBytes(mb: maxSize)
    }
  
   func get(_ key: String) -> T? {
    pthread_rwlock_rdlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
   
        guard let val = mCache[key] else  { return nil }
        return val
  }

     func add(_ key: String, val: T, isUpdate: Bool = true) {
        pthread_rwlock_wrlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
   
            if key.isEmpty { return  }
        var needAdd = false
        let item = mCache[key]
        
        if item == nil  {
           needAdd = true
        }
        if item != nil && isUpdate {
             self.mCurrentSize -= self.getSizeObject(obj: item!)
              remove(key)
              needAdd = true
        }
        if needAdd {
           
          
            insert(key, val: val)
           
            evict()
        }
    }
    

    
    open func getSizeObject(obj: T) -> Int64 {
    
        return 1000
    }
    
    func clear(){
        mCache.removeAll()
        mPriority =  LinkedList<String>()
        mKey2node = [:]
        mCurrentSize = 0
        
    }
    func size()-> Int64 {
        return self.mCurrentSize
    }
  
  private func remove(_ key: String) {
    
    if let obj = mCache[key] {
       mCache.removeValue(forKey: key)
        let sizeObjc = getSizeObject(obj:obj )
        mCurrentSize -= sizeObjc
    }
    
    guard let node = mKey2node[key] else { return }
       mPriority.remove(node: node)
       mKey2node.removeValue(forKey: key)
       
  }
  
    private func insert(_ key: String, val: T) {
        let sizeObjc = getSizeObject(obj: val)
        if sizeObjc >= mMaxSize { return }
        mCurrentSize += sizeObjc
        
        mCache[key] = val
        mPriority.insert(key, atIndex: 0)
        guard let first = mPriority.first else {return}
        mKey2node[key] = first
        
        evict()
    }
    
    
    func evict(){
        trimToSize((mMaxSize * 70) / 100)
    }
    
    private var mEvictWithBarrier = false
    func evictWithBarrier(_ bool: Bool){
        mEvictWithBarrier = bool
    }
    
    func trimToSize(_ size: Int64){
        if mCurrentSize >= mMaxSize {
            if mEvictWithBarrier {
                Guiso.get().getExecutor().doWorkBarrier{
                    while let key = self.mPriority.last?.value {
                        
                        if self.mCurrentSize <= size {
                            if self.mCurrentSize < 0 { self.mCurrentSize = 0}
                            break
                            
                        }
                        self.remove(key)
                      
                    }
                    
                }
            }else{
                while let key = self.mPriority.last?.value {
                    if self.mCurrentSize <= size {
                        if self.mCurrentSize < 0 { self.mCurrentSize = 0}
                        break
                        
                    }
                    self.remove(key)
                    
                }
            }
            
        }
    }
    
    
   @objc func appMemoryWarning(notification:Notification){
         clear()
    }
    
    
      deinit {
          pthread_rwlock_destroy(&mLock)
          NotificationCenter.default.removeObserver(self)
      }
}
