//
//  JJBadgeVi.swift
//  Jjbadge
//
//  Created by Juan J LF on 3/11/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(Badge)
class Badge: RCTViewManager {

    override func view() -> UIView! {
    
       return BadgeView()
     }
      
    override func shadowView() -> RCTShadowView {
        return BadgeShadowView()
    }
    
    
    override static func requiresMainQueueSetup() -> Bool {
      return true
    }
 

    
    
    
}
