//
//  extension_CALayer.swift
//  AnimationPractica
//
//  Created by Juan J LF on 3/24/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit


public extension CALayer {
    
    @discardableResult
    func addSublayers(_ layers: CALayer...) -> CALayer {
        layers.forEach { (l) in
            self.addSublayer(l)
        }
        return self
    }
    
    enum Gravity {
        case top,
        left,
        bottom,
        right
    }

}
