//
//  GuisoFallbackHolder.swift
//  Guiso
//
//  Created by Juan J LF on 5/20/20.
//

import UIKit

class GuisoFallbackHolder {
   
    private var mName:String?
    private var mImage:UIImage?
    private var mTarget: ViewTarget?
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
    
    
    func load() {
        if mImage != nil {
            mTarget?.onHolder(mImage)
        }else if mColor != nil {
            let img = GuisoUtils.imageColor(color: mColor!)
            mTarget?.onHolder(img)
        }else{
            let img = UIImage(named: mName ?? "")
              mTarget?.onHolder(img)
        }
    }
    
    func setTarget(_ target:ViewTarget?){
        mTarget = target
    }
}
