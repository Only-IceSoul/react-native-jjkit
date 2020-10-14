//
//  JJMargin.swift
//  JJLayout
//
//  Created by Juan J LF on 10/12/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit

class JJMargin {
    
    var left:CGFloat = 0
    var right:CGFloat = 0
    var top:CGFloat = 0
    var bottom:CGFloat = 0
    init(_ left:CGFloat = 0,_ top:CGFloat = 0,_ right:CGFloat = 0,_ bottom:CGFloat = 0) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
    
    static func top(top: CGFloat) -> JJMargin {
        return JJMargin(0,top,0,0)
    }

    static func left(left: CGFloat)-> JJMargin {
        return JJMargin(left,0,0,0)
    }

    static func right(right: CGFloat)-> JJMargin {
        return JJMargin(0,0,right,0)
    }

    static func bottom(bottom: CGFloat)-> JJMargin {
        return JJMargin(0,0,0,bottom)

    }
    static func horizontal(margin : CGFloat)-> JJMargin {
        return JJMargin(margin,0,margin,0)
    }

    static func vertical(margin : CGFloat)-> JJMargin {
        return JJMargin(0,margin,0,margin)
    }

    static func all(margin: CGFloat) -> JJMargin {
        return JJMargin(margin,margin,margin,margin)
    }


    func sum(left:CGFloat,top:CGFloat,right: CGFloat,bottom: CGFloat) -> JJMargin {
        self.left += left
        self.top += top
        self.right += right
        self.bottom += bottom
        return self
    }

    func add(value: CGFloat) -> JJMargin {
        left += value
        top += value
        right += value
        bottom += value
        return self
    }

    func addHorizontal(value: CGFloat)-> JJMargin {
        left += value
        right += value
        return self
    }

    func addVertical(value: CGFloat) -> JJMargin {
        top += value
        bottom += value
        return self
    }


    func copyAdd(_ a:CGFloat) ->JJMargin {
        return JJMargin(left + a,top+a,right+a,bottom+a)
    }

    func copyAddVertical(_ a:CGFloat)-> JJMargin {
        return JJMargin(left,top+a,right,bottom+a)
    }

    func copyAddHorizontal(_ a:CGFloat) -> JJMargin {
        return JJMargin(left + a,top,right+a,bottom)
    }

    func copyAdd(_ left:CGFloat,_ top:CGFloat,_ right: CGFloat,_ bottom: CGFloat) -> JJMargin {
        return JJMargin(self.left + left,self.top+top,self.right+right,self.bottom+bottom)
    }

     var description :String {
        get {
            return "Left: \(left)  Top: \(top)  Right: \(right) Bottom: \(bottom)"
        }
    }
}
