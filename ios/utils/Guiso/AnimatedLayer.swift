//
//  GifLayer.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/24/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//


import UIKit


public class AnimatedLayer : CALayer {

    private var mDrawable: AnimatedImage!
     private var contentMode : UIView.ContentMode = .scaleAspectFit
  
     public init(_ gif:AnimatedImage){
        super.init()
            self.mDrawable = gif
        if mDrawable.frames.count > 0 {
            let frame =  mDrawable.frames[0]
            if mDrawable.canvasHeight == 0 || mDrawable.canvasWidth == 0 {
                mDrawable.canvasHeight = frame.height
                mDrawable.canvasWidth = frame.width
            }
            
            self.needsDisplay()
        }

     }
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     public func setContentMode(_ mode: UIView.ContentMode){
         self.contentMode = mode
     }
     
    public func getWidth() -> Int {
        return mDrawable.canvasWidth
    }
    
    public func getHeight() -> Int {
        return mDrawable.canvasHeight
    }
    
     private var mCurrentAnimator : CADisplayLink?
     private var mIsAnimating = false

    private var mInit = true
     public func startAnimation() {
        if mDrawable.delays.isEmpty || mDrawable.frames.isEmpty { return }
        if !mIsAnimating && self.mDrawable.frames.count > 0{
            mInit = true
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
    private var mFrameInterval:Double = 0
    private var mCurrentFrame:Double = 0
     @objc func makeAnimation(_ link:CADisplayLink){
        
        if mInit {
            mInit = false
            mFrameInterval = self.mDrawable.delays[self.index]
            self.needsDisplay()
        }
        
        if mCurrentFrame >= mFrameInterval {
            self.index += 1
            if self.index > self.mDrawable.frames.count - 1 { self.index = 0}
            self.setNeedsDisplay()
            mCurrentFrame = 0
            mFrameInterval = self.mDrawable.delays[self.index]
            
        }
        mCurrentFrame += link.duration
     }
    
     public func isAnimating() -> Bool {
         return mIsAnimating
     }

     
    override  public func display() {
         super.display()
         self.contents =  self.mDrawable.frames[self.index]
     }
     

     public func onBoundsChange(_ bounds: CGRect){
            invalidateFrame(bounds)
       }
     
     private var mMainRect = CGRect.zero
     private func invalidateFrame(_ bounds:CGRect){
        let rect = TransformationUtils.getRect(cw:CGFloat(mDrawable.canvasWidth),ch:CGFloat(mDrawable.canvasHeight), width: bounds.width, height: bounds.height, self.contentMode)
         super.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        super.position.x = bounds.midX
         super.position.y = bounds.midY
     
     }
}

