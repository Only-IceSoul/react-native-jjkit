//
//  GuisoErrorHolder.swift
//  Guiso
//
//  Created by Juan J LF on 5/20/20.
//

import UIKit


class GuisoErrorHolder {
   
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
    
    
    func load(_ isThumb:Bool = false) {
        if mImage != nil {
            updateTarget(isThumb,mImage)
        }else if mColor != nil {
            let img = GuisoUtils.imageColor(color: mColor!)
            updateTarget(isThumb,img)
        }else{
            let img = UIImage(named: mName ?? "")
            updateTarget(isThumb,img)
        }
    }
    
    func updateTarget(_ ist:Bool,_ img:UIImage?){
        if ist {
            mTarget?.onThumbReady(img)
        }else{
            mTarget?.onHolder(img)
        }
    }
    
    func setTarget(_ target:ViewTarget?){
        mTarget = target
    }
}
