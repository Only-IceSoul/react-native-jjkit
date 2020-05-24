//
//  GifLayer.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/24/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//


import UIKit


public class GifLayer : CALayer {

    private var gifDrawable: Gif!
     private var contentMode : UIView.ContentMode = .scaleAspectFit
  
     public init(_ gif:Gif){
        super.init()
            self.gifDrawable = gif

     }
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     public func setContentMode(_ mode: UIView.ContentMode){
         self.contentMode = mode
     }
     
    
     private var mCurrentAnimator : CADisplayLink?
     private var mIsAnimating = false

     public func startAnimation() {
        if !mIsAnimating && self.gifDrawable.frames.count > 0{
             mIsAnimating = true
            mCurrentAnimator = CADisplayLink(target: self, selector: #selector(makeAnimation(_:)))
              
            mCurrentAnimator?.add(to: .main, forMode: .default)
           
           
         }
     }
     
     public func stopAnimation(){
         mCurrentAnimator?.invalidate()
         mCurrentAnimator = nil
         mIsAnimating = false
     }
     
     private var index = 0
    private var mCurrentTime = 0
    private var mFrameRate = 0
    private var mFrameInterval = 0
    private var mCurrentFrame = 1
     @objc func makeAnimation(_ link:CADisplayLink){
        
        if mFrameRate == 0 {
            mFrameRate = Int(round(1.0 / Double(link.duration)))
            mFrameInterval = Int(Double(mFrameRate) / (Double(gifDrawable.frames.count) / gifDrawable.duration))
             self.setNeedsDisplay()
        }
        
        if mCurrentFrame >= mFrameInterval {
            self.index += 1
            if self.index > self.gifDrawable.frames.count - 1 { self.index = 0}
            self.setNeedsDisplay()
            mCurrentFrame = 0
        }
            mCurrentFrame += 1
     }
    
     public func isAnimating() -> Bool {
         return mIsAnimating
     }

     
    override  public func display() {
         super.display()
         self.contents =  self.gifDrawable.frames[self.index]
     }
     

     public func onBoundsChange(_ bounds: CGRect){
            invalidateFrame(bounds)
       }
     
     private var mMainRect = CGRect.zero
     private func invalidateFrame(_ bounds:CGRect){
         let rect = TransformationUtils.getRect(cgImage: gifDrawable.frames[0], width: bounds.width, height: bounds.height, self.contentMode)
         super.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        super.position.x = bounds.midX
         super.position.y = bounds.midY
     
     }
}

