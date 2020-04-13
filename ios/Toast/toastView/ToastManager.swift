//
//  dasd.swift
//  JjToast
//
//  Created by Juan J LF on 3/5/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

class ToastManager {
     
    static var mCurrentToast : JJLabel?
  
    static func makeText(message:String,duration: Duration){
      
        
        let d = duration == .SHORT ? 2 : 3.5
    
            mCurrentToast = JJLabel()
             let padY = CGFloat(JJScreen.point(p: 18))
             let padX = CGFloat(JJScreen.point(p: 30))
        
            let isLandscape = UIScreen.main.bounds.height < UIScreen.main.bounds.width
            let sizeW = JJScreen.percentWidth(percent: 0.8)
            let sizeH = JJScreen.percentHeight(percent: 0.8)
       
            let margin = isLandscape ? JJScreen.percentWidth(percent: 0.1) : JJScreen.percentHeight(percent: 0.06)
             
             mCurrentToast!.setText(text: message)
                 .setTextColor(UIColor.white)
                 .setTextAlignment(.center)
                 .setFont(UIFont.systemFont(ofSize: JJScreen.point(p: 20)))
                 .setClipShape(.dynamicRoundedText)
                 .setNumberOfLines(0)
                 .setAlpha(0)
                 .setPadding(pad: UIEdgeInsets(top: padY, left: padX, bottom: padY ,right: padX ))
                 .setBackgroundColor(color: UIColor.parseColor("#F0656565"))
             
             if let window = UIWindow.key {
             
                var contentSize = CGSize.zero
               message.sizeHeight(width: sizeW, font: UIFont.systemFont(ofSize: JJScreen.point(p: 20)), cgSize: &contentSize)

                 window.addSubview(mCurrentToast!)
               if contentSize.height >= sizeW && isLandscape {
                     mCurrentToast!.clCenterInParentVertically()
                
                }else {
                    mCurrentToast!.clBottomToBottomParent(margin: margin )
                }
                mCurrentToast!
                     .clCenterInParentHorizontally()
                     .clWidthLessEqualTo(size: sizeW)
                    .clHeightLessEqualTo(size: sizeH)
                     .clApply()
                 
                 
                
                 UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                     
                     mCurrentToast!.alpha = 1.0
                     
                 }) { (isEnded) in
                 
                                
                     if(isEnded){
                        
                        Timer.scheduledTimer(timeInterval: TimeInterval(d), target: ToastManager.self, selector: #selector(ToastManager.perfomTimer(_:)), userInfo: nil, repeats: false)
                        
                     } else {
                        DispatchQueue.main.async {
                          mCurrentToast!.removeFromSuperview()
                            mCurrentToast = nil
                        }
                     }
                 }
             
             }
             
         } //endfunction
        
    
    @objc static func perfomTimer(_ sender:Timer){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.65, delay: 0, options: .curveEaseOut, animations: {

                ToastManager.mCurrentToast?.alpha = 0

            }, completion: { (isEnded) in
            ToastManager.mCurrentToast?.removeFromSuperview()
               ToastManager.mCurrentToast = nil
            })
       }
    }
    
    enum Duration {
           case SHORT,
           LONG
       }
}
