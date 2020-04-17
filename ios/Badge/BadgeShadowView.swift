//
//  BadgeShadowView.swift
//  react-native-jjbadge
//
//  Created by Juan J LF on 3/12/20.
//

import UIKit


class BadgeShadowView: RCTShadowView {
    
 
    override init() {
        super.init()
        
        YGNodeSetMeasureFunc(self.yogaNode, BadgeShadowView.onMeasureFunction)
    }
    
    private var mText = NSMutableAttributedString(string: "99+")
   @objc func setText(_ text:String?){
        mText.mutableString.setString((text ?? "99+"))
        markUpdated()
    }
    
    private var mTextSize:CGFloat = 15
    @objc func setTextSize(_ size:CGFloat){
         mTextSize = size
         markUpdated()
     }
    
    private var mFont = "default"
    @objc func setFont(_ font: String?){
        mFont = font ?? "default"
    }
    
       private var mInsetX :CGFloat = 0
      @objc func setInsetX(_ value: CGFloat){
        mInsetX = value / 100
        markUpdated()
    }
    
    private var mInsetY :CGFloat = 0
      @objc func setInsetY(_ value: CGFloat){
        mInsetY = value / 100
        markUpdated()
    }
    
    
    override func didSetProps(_ changedProps: [String]!) {}
     
    private var mDesiredWidth :Float = 0
    private var mDesiredHeight :Float = 0
    private var mBoundsText = CGSize()
    private func computeWrapContentSize(){
        if(mText.length > 0){
            mFont = mFont == "default" ? "default" : String(mFont.split(separator: ".")[0])
            let f =  mFont == "default" ? UIFont.systemFont(ofSize: mTextSize) : UIFont(name: mFont, size: mTextSize)!
            mText.addAttribute(.font, value: f , range: NSRange(location: 0, length: mText.length))
            mText.sizeOneLine(cgSize: &mBoundsText)
            let iX = self.mText.length > 2 ? 0.5 + mInsetX : 0.6 + mInsetX
            let iY = 0.3 + mInsetY
            let fiX = iX < 0 ? 0 : iX
            let fiY = iY < 0 ? 0 : iY
            let margin = mBoundsText.height * fiY
            let marginW = mBoundsText.width * fiX
            
            mDesiredWidth = Float(mBoundsText.width + marginW)
            mDesiredHeight = Float(mBoundsText.height + margin)
       
            if(mText.length == 1){
                mDesiredWidth = mDesiredHeight
            }
        }else {
            mDesiredHeight = 0
            mDesiredWidth = 0
        }
    }
    
    static let onMeasureFunction : YGMeasureFunc = {
        node, width,widthMode,height,heightMode -> YGSize in
        let context = YGNodeGetContext(node) as UnsafeMutableRawPointer
        let mySelf = Unmanaged<BadgeShadowView>.fromOpaque(context).takeUnretainedValue()
        mySelf.computeWrapContentSize()
        let finalW = widthMode.rawValue == 0 || widthMode.rawValue == 2 ? mySelf.mDesiredWidth : width
        let finalH = heightMode.rawValue == 0 || heightMode.rawValue == 2 ? mySelf.mDesiredHeight : height
        return YGSize(width: finalW,height: finalH)
    }
    
    func markUpdated(){
        YGNodeMarkDirty(self.yogaNode)
    }
}
