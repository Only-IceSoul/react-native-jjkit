//
//  JJLayerClipOriginalOriginal.swift
//  AnimationPractica
//
//  Created by Juan J LF on 3/27/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit


class LayerClip : CAShapeLayer {
    

    private var mGravity : Gravity = .top
    private var mInset : CGFloat = 0



    convenience init(gravity: Gravity){
       self.init()
       mGravity = gravity
       super.fillColor = UIColor.blue.cgColor
    }

    override init() {
       super.init()
       super.fillColor = UIColor.blue.cgColor
    }
   
    func setGravity(_ gravity:Gravity) {
       mGravity = gravity
    }
    func setInset(inset : CGFloat){
       mInset = inset
    }
  
    func setProgress(_ progress: CGFloat) {
        switch mGravity {
            case .bottom: makeBottom(progress)
            case .top : makeTop(progress)
            case .left : makeLeft(progress)
            case .right : makeRight(progress)
        }
    }
      
    
    private func setupMainPath(){
       mMainPath.removeAllPoints()
       mMainPath.addRect(super.bounds)
    }


    private func makeBottom(_ percent: CGFloat){
        var r = super.bounds.height
        r = r <= 0 ? 0 : r
        let dy = r - (percent  * r )
        setTranslation(dx: 0, dy: dy)
    }

    private func makeTop(_ percent: CGFloat){
        var range = super.bounds.height
        range = range <= 0 ? 0 : range
        let dy = -(range - (percent  * range) )
        setTranslation(dx: 0, dy: dy)
    }

    private func makeRight(_ percent: CGFloat){
        var r = super.bounds.width
       r = r <= 0 ? 0 : r
       let dx = r - (percent  * r )
       setTranslation(dx: dx, dy: 0)
    }

    private func makeLeft(_ percent: CGFloat){
        var r = super.bounds.width
       r = r <= 0 ? 0 : r
       let dx = -(r - (percent  * r) )
       setTranslation(dx: dx, dy: 0)
    }



    //MARK : BASE


    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    private var mFirstTime = true
    func onBoundsChange(_ bounds: CGRect){
        invalidateFrame(bounds)
        if mFirstTime {
            mFirstTime = false
            setProgress(0)
        }

    }
    private var mMainPath  = UIBezierPath()
    private func invalidatePath(){
        setupMainPath()
        super.path = mMainPath.cgPath
    }
    private var mMainRect = CGRect()
    private func invalidateFrame(_ bounds:CGRect){
        mMainRect.set(rect: bounds)
        if mGravity == .bottom || mGravity == .top {
            mMainRect.setInset(dx: 0, dy: mInset)
       }
       else {
            mMainRect.setInset(dx: mInset, dy: 0)
       }
              
        super.frame = mMainRect
        super.position.x = bounds.center.x
        super.position.y = bounds.center.y
        invalidatePath()
    }

    private var mTx : CGFloat = 0
    private var mTy : CGFloat = 0
    private func setTranslation(dx:CGFloat,dy:CGFloat) {
     mTx = dx
     mTy = dy
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
    let localTransfrom  = CATransform3DMakeTranslation(mTx, mTy, 0)
           super.transform = localTransfrom
    }
    private func disableAnimation(){
      CATransaction.begin()
      CATransaction.setDisableActions(true)
    }
    private func commit(){
      CATransaction.commit()
    }

    
}
