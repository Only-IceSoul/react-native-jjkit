//
//  LRUCacheGif.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/24/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import Foundation


 class LRUCacheGif : LRUCache<Gif> {
    
    
     override func getSizeObject(obj: Gif) -> Double {
        return 1
    }
}
