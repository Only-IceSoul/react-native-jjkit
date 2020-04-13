//
//  JJScreen.swift
//  CreatingViewComponents
//
//  Created by Juan J LF on 4/3/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit


class JJScreen {
    
    static let height = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    
    static let width = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    
    
    static func percentHeight(percent: CGFloat)-> CGFloat {
        return CGFloat(height)  * percent
    }
    
    static func percentWidth(percent: CGFloat)-> CGFloat {
        return CGFloat(width)  * percent
    }
    
    static func point(p: CGFloat) -> CGFloat{
        let percent = CGFloat(p) / 1000
        return percent * CGFloat(height)
    }
    
    static func pointW(p: CGFloat) -> CGFloat{
        let percent = CGFloat(p) / 1000
        return percent * CGFloat(width)
    }
}
