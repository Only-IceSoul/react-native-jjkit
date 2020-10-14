//
//  JJLayout.swift
//  JJLayout
//
//  Created by Juan J LF on 10/12/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit


 class JJLayout  {
    
     private var mClView : UIView?
     private var mContraints = [NSLayoutConstraint]()
    @discardableResult
    func clSetView(view:UIView,_ ancestor:Bool = false) -> JJLayout{
         mClView?.translatesAutoresizingMaskIntoConstraints = false
         mClView = view
        mContraints = getContraints(ancestor)
         return self
     }
    @discardableResult
     func clDisposeView() -> JJLayout{
           mClView = nil
        mContraints = [NSLayoutConstraint]()
           return self
        
    }
    @discardableResult
    func clFillParent(_ margin:JJMargin = JJMargin()) -> JJLayout{
    
        guard let s = mClView?.superview else { return self }
        disableContraints()
        
        mClView?.topAnchor.constraint(equalTo: s.topAnchor,constant: margin.top).isActive = true
        mClView?.bottomAnchor.constraint(equalTo: s.bottomAnchor,constant: -margin.bottom).isActive = true
        mClView?.leadingAnchor.constraint(equalTo: s.leadingAnchor,constant: margin.left).isActive = true
        mClView?.trailingAnchor.constraint(equalTo: s.trailingAnchor,constant: -margin.right).isActive = true
        
        return self
    }
    
    @discardableResult
    func clFillParentHorizontally(_ startMargin: CGFloat = 0,_ endMargin:CGFloat = 0) -> JJLayout{
        
        guard let s = mClView?.superview else { return self }
        getAxisXConstraints().forEach { (c) in
            c.isActive = false
        }
        mClView?.leadingAnchor.constraint(equalTo: s.leadingAnchor,constant: startMargin).isActive = true
        mClView?.trailingAnchor.constraint(equalTo: s.trailingAnchor,constant: -endMargin).isActive = true
        
        
        return self
    }
    
    @discardableResult
    func clFillParentVertically(_ topMargin: CGFloat = 0,_ bottomMargin:CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getAxisYConstraints().forEach { (c) in
            c.isActive = false
        }
        mClView?.topAnchor.constraint(equalTo: s.topAnchor,constant: topMargin).isActive = true
        mClView?.bottomAnchor.constraint(equalTo: s.bottomAnchor,constant: -bottomMargin).isActive = true
         
           return self
    }
    
    @discardableResult
    func clCenterInParent(_ constantX: CGFloat = 0,_ constantY: CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getAxisXConstraints().forEach { (c) in
            c.isActive = false
        }
        getAxisYConstraints().forEach { (c) in
            c.isActive = false
        }
 
        mClView?.centerXAnchor.constraint(equalTo: s.centerXAnchor, constant: constantX).isActive = true
        mClView?.centerYAnchor.constraint(equalTo: s.centerYAnchor, constant: constantY).isActive = true
        
         return self
     }
    
    @discardableResult
    func clCenterInParentHorizontally(_ constantX: CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getAxisXConstraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.centerXAnchor.constraint(equalTo: s.centerXAnchor, constant: constantX).isActive = true
            return self
     }
    
     @discardableResult
     func clCenterInParentVertically(_ constantY: CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getAxisYConstraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.centerYAnchor.constraint(equalTo: s.centerYAnchor, constant: constantY).isActive = true
                
            return self
     }
    
   
    @discardableResult
    func clTopToTopParent(_ margin:CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
          
        getTopContraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.topAnchor.constraint(equalTo: s.topAnchor, constant: margin).isActive = true
        
          return self
    }
    
    @discardableResult
    func clBottomToBottomParent(_ margin:CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getBottomContraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.bottomAnchor.constraint(equalTo: s.bottomAnchor, constant: -margin).isActive = true
        
        return self
    }
    
    @discardableResult
    func clLeadingToLeadingParent(_ margin:CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getLeadingContraints().forEach { (c) in
            c.isActive = false
        }
        getLeftContraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.leadingAnchor.constraint(equalTo: s.leadingAnchor, constant: margin).isActive = true
     
      
           
           return self
    }
    
    @discardableResult
    func clTrailingToTrailingParent(_ margin:CGFloat = 0) -> JJLayout{
           
        guard let s = mClView?.superview else { return self }
        getTrailingContraints().forEach { (c) in
            c.isActive = false
        }
        getRightContraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.trailingAnchor.constraint(equalTo: s.trailingAnchor, constant: -margin).isActive = true
     
           return self
    }
    
    @discardableResult
       func clTopToBottomParent(_ margin:CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getTopContraints().forEach { (c) in
            c.isActive = false
        }
       
        mClView?.topAnchor.constraint(equalTo: s.bottomAnchor, constant: margin).isActive = true
             return self
       }
       
       @discardableResult
       func clBottomToTopParent(_ margin:CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getBottomContraints().forEach { (c) in
            c.isActive = false
        }
       
        mClView?.bottomAnchor.constraint(equalTo: s.topAnchor, constant: -margin).isActive = true
           return self
       }
       
       @discardableResult
       func clStartToEndParent( margin:CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getLeadingContraints().forEach { (c) in
            c.isActive = false
        }
        getLeftContraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.leadingAnchor.constraint(equalTo: s.trailingAnchor, constant: margin).isActive = true
     
              
              return self
       }
       
       @discardableResult
       func clEndToStartParent(_ margin:CGFloat = 0) -> JJLayout{
        guard let s = mClView?.superview else { return self }
        getTrailingContraints().forEach { (c) in
            c.isActive = false
        }
        getRightContraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.trailingAnchor.constraint(equalTo: s.leadingAnchor, constant: -margin).isActive = true
     
              return self
       }
    
    
    @discardableResult
    func clWidth(size:CGFloat) -> JJLayout{
        getWidthConstraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.widthAnchor.constraint(equalToConstant: size).isActive = true
            
            return self
     }
    @discardableResult
    func clHeight(size:CGFloat) -> JJLayout{
        getHeightConstraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.heightAnchor.constraint(equalToConstant: size).isActive = true
            
            return self
    }
    
    @discardableResult
    func clWidthEqualTo(anchor:NSLayoutDimension,_ multiplier: CGFloat = 1) -> JJLayout{
        getWidthConstraints().forEach { (c) in
            c.isActive = false
        }
             
        mClView?.widthAnchor.constraint(equalTo: anchor, multiplier: multiplier).isActive = true
               
            return self
        }
    @discardableResult
    func clHeightEqualTo(anchor: NSLayoutDimension,_ multiplier: CGFloat = 1) -> JJLayout{
               
        getHeightConstraints().forEach { (c) in
            c.isActive = false
        }
             
        mClView?.heightAnchor.constraint(equalTo: anchor, multiplier: multiplier).isActive = true
               return self
    }
    
    @discardableResult
    func clWidthLessEqualTo(anchor:NSLayoutDimension,_ multiplier: CGFloat = 1) -> JJLayout{
        getWidthConstraints().forEach { (c) in
            c.isActive = false
        }
             
        mClView?.widthAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier).isActive = true
               
            return self
        }
    @discardableResult
    func clHeightLessEqualTo(anchor: NSLayoutDimension,_ multiplier: CGFloat = 1) -> JJLayout{
               
        getHeightConstraints().forEach { (c) in
            c.isActive = false
        }
             
        mClView?.heightAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier).isActive = true
               return self
    }
    
    @discardableResult
    func clWidthGreaterEqualTo(anchor:NSLayoutDimension,_ multiplier: CGFloat = 1) -> JJLayout{
        getWidthConstraints().forEach { (c) in
            c.isActive = false
        }
             
        mClView?.widthAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier).isActive = true
               
            return self
        }
    @discardableResult
    func clHeightGreaterEqualTo(anchor: NSLayoutDimension,_ multiplier: CGFloat = 1) -> JJLayout{
               
        getHeightConstraints().forEach { (c) in
            c.isActive = false
        }
             
        mClView?.heightAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier).isActive = true
               return self
    }
 
 
    @discardableResult
     func clWidthLessEqualTo(size:CGFloat) -> JJLayout{
        getWidthConstraints().forEach { (c) in
            c.isActive = false
        }
        mClView?.widthAnchor.constraint(lessThanOrEqualToConstant: size).isActive = true
               return self
     }
     
     @discardableResult
       func clHeightLessEqualTo(size:CGFloat) -> JJLayout{
        getHeightConstraints().forEach { (c) in
            c.isActive = false
        }
        
        mClView?.heightAnchor.constraint(lessThanOrEqualToConstant: size).isActive = true
          return self
       }
   
   @discardableResult
     func clWidthGreaterEqualTo(size:CGFloat) -> JJLayout{
        getWidthConstraints().forEach { (c) in
            c.isActive = false
        }
     
        mClView?.widthAnchor.constraint(greaterThanOrEqualToConstant: size).isActive = true
        
               return self
     }
     
     @discardableResult
       func clHeightGreaterEqualTo(size:CGFloat) -> JJLayout{
        getHeightConstraints().forEach { (c) in
            c.isActive = false
        }
        mClView?.heightAnchor.constraint(greaterThanOrEqualToConstant: size).isActive = true
                 return self
       }
   
    
    @discardableResult
    func clTopToTopOf(view:UIView, margin:CGFloat = 0) -> JJLayout{
            
        getTopContraints().forEach { (c) in
            c.isActive = false
        }
      
        mClView?.topAnchor.constraint(equalTo: view.topAnchor, constant: margin).isActive = true
        
            return self
      }
      
      @discardableResult
    func clBottomToBottomOf(view:UIView, margin:CGFloat = 0) -> JJLayout{
        getBottomContraints().forEach { (c) in
            c.isActive = false
        }
      
        mClView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin).isActive = true
          
          return self
      }
      
      @discardableResult
    func clLeadingToLeadingOf(view: UIView, margin:CGFloat = 0) -> JJLayout{
        getLeadingContraints().forEach { (c) in
            c.isActive = false
        }
      
        mClView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
             
             return self
      }
      
      @discardableResult
    func clTrailingToTrailingOf(view:UIView, margin:CGFloat = 0) -> JJLayout{
        
        getTrailingContraints().forEach { (c) in
            c.isActive = false
        }
      
        mClView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
             return self
      }
    
    
    
    @discardableResult
    func clTopToBottomOf(view:UIView, margin:CGFloat = 0) -> JJLayout{
        getTopContraints().forEach { (c) in
            c.isActive = false
        }
      
        mClView?.topAnchor.constraint(equalTo: view.bottomAnchor, constant: margin).isActive = true
            
            return self
      }
      
      @discardableResult
    func clBottomToTopOf(view:UIView, margin:CGFloat = 0) -> JJLayout{

        getBottomContraints().forEach { (c) in
            c.isActive = false
        }
      
        mClView?.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -margin).isActive = true
          
          return self
      }
      
      @discardableResult
    func clLeadingToTrailingOf(view: UIView, margin:CGFloat = 0) -> JJLayout{
        getLeadingContraints().forEach { (c) in
            c.isActive = false
        }
      
        mClView?.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: margin).isActive = true
             
             return self
      }
      
      @discardableResult
    func clTrailingToLeadingOf(view:UIView, margin:CGFloat = 0) -> JJLayout{
        

        getTrailingContraints().forEach { (c) in
            c.isActive = false
        }
      
        mClView?.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -margin).isActive = true
             
             return self
      }
    
    @discardableResult
    func clMargins(m: JJMargin) -> JJLayout{
          
        getTopContraints().forEach { (c) in
            c.constant = m.top
        }
        getBottomContraints().forEach { (c) in
            c.constant = -m.bottom
        }
        getTrailingRightContraints().forEach { (c) in
            c.constant = -m.right
        }
        getLeadingLeftContraints().forEach { (c) in
            c.constant = m.left
        }
        return self
     }
    
    @discardableResult
    func clVerticalBiasCenter(value: CGFloat) -> JJLayout{
        getCenterXContraints().forEach { (c) in
            c.constant = value
        }
        return self
     }
    
    @discardableResult
    func clHorizontalBiasCenter(value: CGFloat) -> JJLayout{
        getCenterYContraints().forEach { (c) in
            c.constant = value
        }
        
           return self
    }


    private func disableContraints(){
        mContraints.forEach { (c) in
            c.isActive = false
        }
    }
    
    func getContraints(_ ancestor:Bool) -> [NSLayoutConstraint]{
       
        if mClView == nil { return [NSLayoutConstraint]() }
        
        var views = [mClView!]
        if(ancestor){
            var view = mClView!
            while let superview = view.superview {
                       views.append(superview)
                       view = superview
                   }
        }else{
            if let s = mClView!.superview {
                views.append(s)
            }
        }
        return views.flatMap({ $0.constraints }).filter { constraint in
                    return constraint.firstItem as? UIView == mClView! ||
                        constraint.secondItem as? UIView == mClView!
                }
    }
    
    func getWidthConstantConstraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                ($0.firstAttribute == .width &&
                    $0.relation == .equal &&
                    $0.secondAttribute == .notAnAttribute)
            } )
    }
    
    func getHeightConstantConstraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                ($0.firstAttribute == .height &&
                    $0.relation == .equal &&
                    $0.secondAttribute == .notAnAttribute)
            } )
    }
    
    func getWidthConstraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .width ||
                $0.secondAttribute == .width
            } )
    }
    
    func getHeightConstraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .height  ||
                $0.secondAttribute == .height
            } )
    }
    
    func getAxisXConstraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .leading  ||
                $0.secondAttribute == .leading  ||
                $0.firstAttribute == .trailing ||
                $0.secondAttribute == .trailing  ||
                $0.firstAttribute == .left  ||
                $0.secondAttribute == .left  ||
                $0.firstAttribute == .right   ||
                $0.secondAttribute == .right   ||
                    $0.firstAttribute == .leadingMargin   ||
                    $0.secondAttribute == .leadingMargin   ||
                    $0.firstAttribute == .trailingMargin   ||
                    $0.secondAttribute == .trailingMargin   ||
                    $0.firstAttribute == .leftMargin  ||
                    $0.secondAttribute == .leftMargin   ||
                    $0.firstAttribute == .rightMargin   ||
                    $0.secondAttribute == .rightMargin
                    
            } )
    }
    
    func getAxisYConstraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .top  ||
                $0.secondAttribute == .top  ||
                $0.firstAttribute == .bottom ||
                $0.secondAttribute == .bottom  ||
                $0.firstAttribute == .topMargin  ||
                $0.secondAttribute == .topMargin  ||
                $0.firstAttribute == .bottomMargin   ||
                $0.secondAttribute == .bottomMargin
            } )
    }
    
    func getLeadingContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .leading  ||
                $0.secondAttribute == .leading  ||
                $0.firstAttribute == .leadingMargin   ||
                $0.secondAttribute == .leadingMargin
                  
            } )
    }
    
    
    
    func getTrailingContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .trailing  ||
                $0.secondAttribute == .trailing  ||
                $0.firstAttribute == .trailingMargin   ||
                $0.secondAttribute == .trailingMargin
            } )
    }
    
    func getLeftContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .left  ||
                $0.secondAttribute == .left  ||
                $0.firstAttribute == .leftMargin   ||
                $0.secondAttribute == .leftMargin
            } )
    }
    
    func getRightContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .right  ||
                $0.secondAttribute == .right  ||
                $0.firstAttribute == .rightMargin   ||
                $0.secondAttribute == .rightMargin
            } )
    }
    
    func getLeadingLeftContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .leading  ||
                $0.secondAttribute == .leading  ||
                $0.firstAttribute == .leadingMargin   ||
                $0.secondAttribute == .leadingMargin ||
                $0.firstAttribute == .left  ||
                $0.secondAttribute == .left  ||
                $0.firstAttribute == .leftMargin   ||
                $0.secondAttribute == .leftMargin
                  
            } )
    }
    
    func getTrailingRightContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .trailing  ||
                $0.secondAttribute == .trailing  ||
                $0.firstAttribute == .trailingMargin   ||
                $0.secondAttribute == .trailingMargin ||
                $0.firstAttribute == .right  ||
                $0.secondAttribute == .right  ||
                $0.firstAttribute == .rightMargin   ||
                $0.secondAttribute == .rightMargin
            } )
    }
    
    func getCenterContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .centerY  ||
                $0.secondAttribute == .centerY  ||
                $0.firstAttribute == .centerX   ||
                $0.secondAttribute == .centerX ||
                $0.firstAttribute == .centerYWithinMargins  ||
                $0.secondAttribute == .centerYWithinMargins  ||
                $0.firstAttribute == .centerXWithinMargins   ||
                $0.secondAttribute == .centerXWithinMargins
            } )
    }
    func getCenterXContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
            
                $0.firstAttribute == .centerX   ||
                $0.secondAttribute == .centerX ||
                $0.firstAttribute == .centerXWithinMargins   ||
                $0.secondAttribute == .centerXWithinMargins
            } )
    }
    
    func getCenterYContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .centerY  ||
                $0.secondAttribute == .centerY  ||
                $0.firstAttribute == .centerYWithinMargins  ||
                $0.secondAttribute == .centerYWithinMargins
           
            } )
    }
    
    func getTopContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .top  ||
                $0.secondAttribute == .top  ||
                $0.firstAttribute == .topMargin  ||
                $0.secondAttribute == .topMargin
           
            } )
    }
    
    func getBottomContraints() -> [NSLayoutConstraint] {
        if mClView == nil { return [NSLayoutConstraint]()}
            return mContraints.filter( {
                $0.firstAttribute == .bottom  ||
                $0.secondAttribute == .bottom  ||
                $0.firstAttribute == .bottomMargin  ||
                $0.secondAttribute == .bottomMargin
           
            } )
    }
    
}
