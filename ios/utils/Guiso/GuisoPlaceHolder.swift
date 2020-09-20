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
    private var mOptions: GuisoOptions?
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

    func setOptions(options:GuisoOptions) -> GuisoPlaceHolder{
        mOptions = options
        return self
    }

    func load() {
       if mImage != nil {
        if let img = transformImage(img: mImage!){
           mTarget?.onHolder(img)
        }
       }else if mColor != nil {
        if let img = transformImage(img: GuisoUtils.imageColor(color: mColor!)){
           mTarget?.onHolder(img)
        }
       }else{
            if let img = transformImage(img: UIImage(named: mName ?? "")){
                mTarget?.onHolder(img)
            }
       }
    }

    func setTarget(_ target:ViewTarget?) -> GuisoPlaceHolder{
       mTarget = target
        return self
    }
    
    private func transformImage(img:UIImage?) -> UIImage?{
        if(img == nil){ return nil }
        var result: UIImage?
        if(mOptions != nil && mOptions?.getIsOverride() == true){
        result = GuisoTransform(scale: mOptions!.getScaleType(), l: mOptions!.getLanczos())
          .transformImage(img: img!, outWidth: mOptions!.getWidth(), outHeight: mOptions!.getHeight())
        }else{
          result = img
        }
        
        return result
    }
    
    
}
