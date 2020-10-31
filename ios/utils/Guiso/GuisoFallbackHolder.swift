//
//  GuisoFallbackHolder.swift
//  Guiso
//
//  Created by Juan J LF on 5/20/20.
//

import UIKit

class GuisoFallbackHolder : Equatable {
   
    static func == (lhs: GuisoFallbackHolder, rhs: GuisoFallbackHolder) -> Bool {
        return lhs.mName == rhs.mName
            && (lhs.mImage == nil && rhs.mImage == nil)
            && lhs.mColor == rhs.mColor
    }
    
    private var mName:String?
    private var mImage:UIImage?
    private var mColor: UIColor?
    init(_ name:String) {
        mName = name
        mImage = nil
        mColor = nil
    }
    
    init(_ image:UIImage) {
       mName = nil
       mImage = image
        mColor = nil
    }
    init(_ color:UIColor) {
       mName = nil
       mImage = nil
        mColor = color
    }
    
    
    func load(_ target:ViewTarget?) {
        if mImage != nil {
            target?.onHolder(mImage)
        }else if mColor != nil {
            let img = GuisoUtils.imageColor(color: mColor!)
            target?.onHolder(img)
        }else{
            let img = UIImage(named: mName ?? "")
            target?.onHolder(img)
        }
    }
    
  
}
