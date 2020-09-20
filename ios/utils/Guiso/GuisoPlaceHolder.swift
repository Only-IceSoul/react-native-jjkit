//
//  GuisoPlaceHolder.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit

class GuisoPlaceHolder {
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
            display(img: mImage!)

        }else if mColor != nil {
            if let img =  GuisoUtils.imageColor(color: mColor!){
                display(img: img)
            }
        }else{
            if let img =  UIImage(named: mName ?? ""){
                display(img: img)
            }
        }
        
    }
    
    private func display(img: UIImage){
        if(!mIsCancelled){
          self.mTarget?.onHolder(img)
        }
    }

    func setTarget(_ target:ViewTarget?) -> GuisoPlaceHolder{
       mTarget = target
        return self
    }
    
 
    
    private var mIsCancelled = false
    func cancel(){
        mIsCancelled = true
    }
    
}
