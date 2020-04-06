//
//  extension_CGRect.swift
//  AnimationPractica
//
//  Created by Juan J LF on 3/24/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit


extension CGRect {
    
    var center : CGPoint {
         return .init(x: midX, y: midY)
    }
    
    @discardableResult
    mutating func setInset(dx: CGFloat,dy:CGFloat) -> CGRect {
        self.origin.x = self.origin.x + dx
        self.origin.y = self.origin.y + dy
        self.size.width = self.size.width - dx*2
        self.size.height = self.size.height - dy*2
        return self
    }
    
    
    @discardableResult
    mutating func set(rect: CGRect) -> CGRect {
        self.origin = rect.origin
        self.size = rect.size
        return self
    }
    
    @discardableResult
    mutating func offset(dx: CGFloat,dy:CGFloat) -> CGRect {
           self.origin.x = self.origin.x + dx
           self.origin.y = self.origin.y + dy
           return self
    }
    
    
}
