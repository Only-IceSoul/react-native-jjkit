//
//  LRUCache.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit
import Foundation

public class LRUCache<U:Hashable,T> {
  private var mMaxSize: Int64 = 0
  private var mCurrentSize : Int64 = 0
    private var mPriority: LinkedList<U,T> = LinkedList<U,T>()
  private var mCache: [U: LinkedList<U,T>.LinkedListNode<U,T>] = [:]
    
   

  public init(_ maxSize: Double) {
    self.mMaxSize = maxSize < 1 ? mbToBytes(mb: 10) : mbToBytes(mb: maxSize)

    
    NotificationCenter.default.addObserver(self, selector: #selector(appMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    
  }
    func mbToBytes(mb:Double)->Int64{
        return Int64(mb * 1048576.0)
    }
    
    public func setMaxSize(_ maxSize: Double){
        self.mMaxSize = mbToBytes(mb: maxSize)
    }
  
    public func get(_ key: U) -> T? {
        guard let val = mCache[key] else  { return nil }
        return val.value
  }

    public func add(_ key: U, val: T) {
        let sizeObjc = getSizeObject(obj: val)
        if sizeObjc >= mMaxSize {
            //evicted cb
            return
        }
        
        mCurrentSize += sizeObjc
        
        if let old = mCache[key] {
            mPriority.remove(node: old)
            mCurrentSize -= getSizeObject(obj: old.value)
            
            //if equal old and item false
            //cb evicted
        }
        
        mPriority.insert(key:key,val, atIndex: 0)
        guard let first = mPriority.first else {return}
        mCache[key] = first
        
        evict()
    }
    

    
    open func getSizeObject(obj: T) -> Int64 {
    
        return 1000
    }
    
    public func clear(){
        mCache.removeAll()
        mPriority.removeAll()
        mCurrentSize = 0
        
    }
    public func size()-> Int64 {
        return self.mCurrentSize
    }
  
  private func remove(_ key: U) {
    guard let node = mCache[key] else { return }
    let sizeObjc = getSizeObject(obj:node.value )
    mCurrentSize -= sizeObjc

    mPriority.remove(node: node)
    mCache.removeValue(forKey: key)
       
  }
  

    
    func evict(){
        if mCurrentSize >= mMaxSize {
            trimToSize((mMaxSize * 90) / 100)
        }
    }

    public func trimToSize(_ size: Int64){
      
        print("trim to size")
        while let key = self.mPriority.last?.key {
            if self.mCurrentSize <= size {
                if self.mCurrentSize < 0 { self.mCurrentSize = 0}
                break
                
            }
               self.remove(key)

        }
            
    }
    
    
   @objc func appMemoryWarning(notification:Notification){
         clear()
    }
    
    
      deinit {
         
          NotificationCenter.default.removeObserver(self)
      }
}
