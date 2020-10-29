//
//  GuisoCache.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 10/28/20.
//

import UIKit


class GuisoCache : LRUCache<UIImage> {
    
    
    
    
    override func getSizeObject(obj: UIImage) -> Int64 {
        return Int64(obj.cgImage!.bytesPerRow * obj.cgImage!.height)
    }
    
    
    
}
