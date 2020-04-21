//
//  LRUCache.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit


public class LRUCache {
  private let mMaxSize: Double
  private var mCurrentSize : Double = 0
  private var mCache: [String: Any] = [:]
  private var mPriority: LinkedList<String> = LinkedList<String>()
  private var mKey2node: [String: LinkedList<String>.LinkedListNode<String>] = [:]
  private let mLock = NSLock()
  public init(_ maxSize: Double) {
    self.mMaxSize = maxSize <= 4 ? 5 : maxSize
    
  }
  
  public func get(_ key: String) -> Any? {
     mLock.lock(); defer { mLock.unlock() }
    guard let val = mCache[key] else {
      return nil
    }
    
    remove(key)
    insert(key, val: val)
    
    return val
  }
  
    public func add(_ key: String, val: Any) {
        objc_sync_enter(mLock); defer { objc_sync_exit(mLock) }

        if mCache[key] != nil {
            remove(key)
        } else if mCurrentSize >= mMaxSize, let keyToRemove = mPriority.last?.value {
            if let obj = mCache[keyToRemove] {
                self.mCurrentSize -= getSizeObject(obj: obj )
            }
            remove(keyToRemove)
        }
        self.mCurrentSize += getSizeObject(obj: val)
            insert(key, val: val)
    }

    open func getSizeObject(obj: Any) -> Double {
        var result: Double = 1
        if let img = obj as? UIImage {
            if let data = img.jpegData(compressionQuality: 1) {
                result = Double(data.count) / 1048576
            }
        }
        return result
    }
    func clear(){
        mCache.removeAll()
        mPriority.removeAll()
        mKey2node.removeAll()
        mCurrentSize = 0
    }
    func size()-> Double {
        return self.mCurrentSize
    }
  
  private func remove(_ key: String) {
    mCache.removeValue(forKey: key)
    guard let node = mKey2node[key] else {
      return
    }
    mPriority.remove(node: node)
    mKey2node.removeValue(forKey: key)
  }
  
  private func insert(_ key: String, val: Any) {
    mCache[key] = val
    mPriority.insert(key, atIndex: 0)
    guard let first = mPriority.first else {
      return
    }
    mKey2node[key] = first
  }
}
