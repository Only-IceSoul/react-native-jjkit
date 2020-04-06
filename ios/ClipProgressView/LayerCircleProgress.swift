//
//  JJCircleProgressOriginalOriginal.swift
//  AnimationPractica
//
//  Created by Juan J LF on 3/27/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit

class LayerCircleProgress: CAShapeLayer {


   private let mLayer = CAShapeLayer()
   private let mLayerBg = CAShapeLayer()
   private let mLayerReverse = CAShapeLayer()
   private let mLayerColor = CAGradientLayer()
   private let mLayerColorBg = CAGradientLayer()
   private let mLayerColorReverse = CAGradientLayer()
   private var mInset : CGFloat = 0

    private var mColors = [ UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.cyan.cgColor,
                            UIColor.blue.cgColor,UIColor.magenta.cgColor,UIColor.red.cgColor]
    private var mColorsBg = [ UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]

    override init() {
        super.init()
        addSublayer(mLayerColorBg)
        addSublayer(mLayerColorReverse)
        addSublayer(mLayerColor)
        
        mLayerColorBg.mask = mLayerBg
        mLayerColorReverse.mask = mLayerReverse
        mLayerColor.mask = mLayer
        
        mLayerColorBg.colors = mColorsBg
        mLayerColor.colors = mColors
        mLayerColorReverse.colors = mColors
        
        mLayerColorBg.startPoint = CGPoint(x: 0.5, y: 0.5)
        mLayerColorBg.endPoint = CGPoint(x: 1, y: 0.5)
        mLayerColor.startPoint = CGPoint(x: 0.5, y: 0.5)
        mLayerColor.endPoint = CGPoint(x: 1, y: 0.5)
        mLayerColorReverse.startPoint = CGPoint(x: 0.5, y: 0.5)
        mLayerColorReverse.endPoint = CGPoint(x: 1, y: 0.5)
        
        mLayerColorBg.type = CAGradientLayerType(rawValue: "conic")
        mLayerColor.type = CAGradientLayerType(rawValue: "conic")
        mLayerColorReverse.type = CAGradientLayerType(rawValue: "conic")
        
        mLayerBg.strokeColor = UIColor.systemPurple.cgColor
        mLayerBg.lineWidth = 4
        mLayerBg.fillColor = UIColor.clear.cgColor
      
        mLayer.strokeColor = UIColor.systemPurple.cgColor
        mLayer.lineWidth = 4
        mLayer.fillColor = UIColor.clear.cgColor
        mLayer.strokeEnd = 0
        mLayerReverse.strokeColor = UIColor.systemPurple.cgColor
        mLayerReverse.lineWidth = 4
        mLayerReverse.fillColor = UIColor.clear.cgColor
        mLayerReverse.strokeEnd = 0
        let radian = (-90 * CGFloat.pi) / 180
         let localTransfrom  = CATransform3DMakeRotation( radian, 0, 0, 1)
         self.transform = localTransfrom
    }
    
    //MARK: SETTER GETTER
    
    func setStrokeWidth(_ size:CGFloat ){
        mLayer.lineWidth = size
        mLayerBg.lineWidth = size
        mLayerReverse.lineWidth = size

    }
   
   func setCap(_ cap: CAShapeLayerLineCap) {
       disableAnimation()
       mLayer.lineCap = cap
       mLayerReverse.lineCap = cap
       mLayerBg.lineCap = cap
       commit()
   }
    func setColor(_ colors: [CGColor]) {
        disableAnimation()
        mLayerColor.colors = colors
        mLayerColorReverse.colors = colors
        commit()
    }
    func setPositions(_ positions:[NSNumber]?){
        disableAnimation()
        mLayerColor.locations = positions
        mLayerColorReverse.locations = positions
        commit()
    }
    func setBackColor(_ colors: [CGColor]){
        disableAnimation()
        mLayerColorBg.colors = colors
        commit()
    }

    func setBackPositions(_ positions:[NSNumber]?){
        disableAnimation()
        mLayerColorBg.locations = positions
        commit()
    }
    
   func setProgress(_ progress: CGFloat) {
        disableAnimation()
        mLayer.strokeEnd = progress > 0 ? progress : 0
        mLayerReverse.strokeEnd = progress < 0 ? progress * -1 : 0
        commit()
   }
  

   
   //MARK : BASE
   
   private var mMainRect = CGRect()
   private var mMainPath  = UIBezierPath()
   private var mPathReverse = UIBezierPath()
   private var mDegrees :CGFloat = 0
    
   private func setupMainPath(){
    let radius = min(super.bounds.width,super.bounds.height) / 2 - mLayerBg.lineWidth / 2
        mMainPath.removeAllPoints()
        mMainPath.addArc(withCenter: super.bounds.center, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        mPathReverse.removeAllPoints()
        mPathReverse.addArc(withCenter: super.bounds.center, radius: radius, startAngle: .pi*2, endAngle: 0 , clockwise: false)
   }
   
   func onBoundsChange(_ bounds: CGRect){
        invalidateFrame(bounds)
   }
   private func invalidatePath(){
       setupMainPath()
       mLayerBg.path = mMainPath.cgPath
       mLayer.path = mMainPath.cgPath
       mLayerReverse.path = mPathReverse.cgPath
    }
    private func invalidateFrame(_ bounds:CGRect){
        mMainRect.set(rect: bounds)
        mMainRect.setInset(dx: mInset, dy: mInset)
        super.frame = mMainRect
        mLayerColorReverse.frame = mMainRect
        mLayerColorBg.frame = mMainRect
        mLayerColor.frame = mMainRect
        invalidatePath()
        super.position.x = bounds.center.x
        super.position.y = bounds.center.y
        mLayerColorBg.position.x = mMainRect.width / 2
        mLayerColorBg.position.y = mMainRect.height / 2
        mLayerColor.position.x = mMainRect.width / 2
        mLayerColor.position.y = mMainRect.height / 2
        mLayerColorReverse.position.x = mMainRect.width / 2
        mLayerColorReverse.position.y = mMainRect.height / 2
    }
  
    func setRotation(degrees: CGFloat){
        mDegrees = degrees
        makeTransform()
    }
 
    private func makeTransform(_ animated:Bool = false){
        if(animated){
          applyTransform()
        }else {
         disableAnimation()
         applyTransform()
         commit()
        }
    }
 
    private func applyTransform(){
        let radian = (mDegrees * .pi) / 180
        let localTransfrom  = CATransform3DMakeRotation( radian, 0, 0, 1)
        self.transform = localTransfrom
        self.mLayerColorBg.transform = localTransfrom
        self.mLayerColor.transform = localTransfrom
        self.mLayerColorReverse.transform = localTransfrom
    }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    private func disableAnimation(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
    }
    private func commit(){  CATransaction.commit() }
    
}
