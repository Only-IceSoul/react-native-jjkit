//
//  GifLayer.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/24/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit


class GifLayer : CALayer {

    private var gifDrawable: GifDrawable!
     private var contentMode : UIView.ContentMode = .scaleAspectFit
  
     init(_ gif:GifDrawable){
            super.init()
            self.gifDrawable = gif

     }
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     func setContentMode(_ mode: UIView.ContentMode){
         self.contentMode = mode
     }
     
     private var index = -1
     private var mCurrentAnimator : Timer?
     private var mIsAnimating = false
     func startAnimation() {
         if !mIsAnimating {
             mIsAnimating = true
             let weakTimer = WeakTimer(target:self,selector:#selector(makeAnimation(_:)))
             mCurrentAnimator =  Timer(timeInterval: self.gifDrawable.interval, target: weakTimer, selector: #selector(WeakTimer.fire(_:)), userInfo: nil, repeats: true)
             RunLoop.main.add(mCurrentAnimator!, forMode: .common)
         }
     }
     
     func stopAnimation(){
         mCurrentAnimator?.invalidate()
         mCurrentAnimator = nil
         mIsAnimating = false
     }
     

     @objc func makeAnimation(_ timer:Timer?){

         self.index += 1
         if self.index > self.gifDrawable.frames.count - 1 { self.index = 0}
         DispatchQueue.main.async {
           self.setNeedsDisplay()
         }

     }
     
     
     func isAnimating() -> Bool {
         return mIsAnimating
     }

     
     override  func display() {
         super.display()
         self.contents =  self.gifDrawable.frames[self.index]
     }
     

     func onBoundsChange(_ bounds: CGRect){
            invalidateFrame(bounds)
       }
     
     private var mMainRect = CGRect.zero
     private func invalidateFrame(_ bounds:CGRect){
         let rect = ImageHelper.getRect(cgImage: gifDrawable.frames[0], width: bounds.width, height: bounds.height, self.contentMode)
         super.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
         super.position.x = bounds.center.x
         super.position.y = bounds.center.y
     
     }
}
