//
//  LRUCacheGif.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/24/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import Foundation


 class LRUCacheGif : LRUCache<GifDrawable> {
    
    
     override func getSizeObject(obj: GifDrawable) -> Double {
        return 1
    }
}
