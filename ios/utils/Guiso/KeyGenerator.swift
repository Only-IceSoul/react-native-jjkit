//
//  File.swift
//  JJGuiso
//
//  Created by Juan J LF on 10/30/20.
//

import Foundation

public class KeyGenerator {
    
    private var mCache = LRUCache<String,String>(2)
    private var mLock = pthread_rwlock_t()
    public init() {
        pthread_rwlock_init(&mLock, nil)
    }
    
    
    public func getKeyString(key:Key)-> String?{
        pthread_rwlock_rdlock(&mLock)
        var str : String?
        let k = key.toString()
         str = mCache.get(k)
        pthread_rwlock_unlock(&mLock)
        if str == nil {
            str = calculateHexString(key: key)
        }
        pthread_rwlock_wrlock(&mLock)
        if str != nil { mCache.add(k, val: str!) }
        pthread_rwlock_unlock(&mLock)
        return str
    }
    
    private func calculateHexString(key:Key) -> String? {
        guard let data = key.digestKey() else { return nil }
        
        var bytes = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &bytes, count: data.count)

         var hexString = ""
         for byte in bytes {
             hexString += String(format:"%02x", UInt8(byte))
         }

    
        return hexString.isEmpty ? nil : hexString
    }
    
}
