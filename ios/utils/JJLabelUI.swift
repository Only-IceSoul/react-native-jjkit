//
//  JJLabel.swift
//  CreatingViewComponents
//
//  Created by Juan J LF on 3/4/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit

class JJLabelUI : UILabel {
    
     private var shape: JJLabelUI.TypeShape = .none
      
    
      override open var bounds: CGRect {
          didSet{
            
              if .none != shape{
                  makeShape(shape: shape)
              }
          }
      }
      
      public init() {super.init(frame:.zero)}
      
      required public init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
   
    
    @discardableResult
    func setNumberOfLines(_ number: Int)-> JJLabelUI{
      self.numberOfLines = number
      return self
    }

    @discardableResult
    func SetMinimumScale(_ factor: CGFloat)-> JJLabelUI{
      self.minimumScaleFactor = factor
      return self
    }
      
    @discardableResult
    func setSizeToFitWidth(bool: Bool)-> JJLabelUI{
      self.adjustsFontSizeToFitWidth = bool
      return self
    }

    @discardableResult
    func setKern(_ value: CGFloat)-> JJLabelUI{
      self.attributedText = self.addAttribute(.kern, value: value)
      return self
    }
    
    @discardableResult
    func setTextUI(text:String) -> JJLabelUI{
        self.text = text
        return self
    }

    @discardableResult
    func setText(text:String) -> JJLabelUI{
        self.attributedText = NSMutableAttributedString(string: text)
        return self
    }
    
    @discardableResult
       func setText(textAttributed:NSAttributedString) -> JJLabelUI{
           self.attributedText = textAttributed
           return self
       }
    
    @discardableResult
    func setSystemFont(size: CGFloat, weight: UIFont.Weight)-> JJLabelUI{
      let font = UIFont.systemFont(ofSize: size, weight: weight)
      self.attributedText = self.addAttribute(.font, value: font)
      return self
    }

    @discardableResult
    func setFont(font: UIFont?)-> JJLabelUI{
      if font !=  nil {
          self.attributedText = self.addAttribute(.font, value: font!)
          
      }
      return self
    }

    fileprivate func addAttribute(_ key: NSAttributedString.Key,value: Any) -> NSAttributedString?{
        if let at = (self.attributedText?.mutableCopy() as? NSMutableAttributedString) {
          if at.length > 0 {
              at.addAttribute(key, value: value, range: NSRange(location:0, length: at.length))
              return at
          }
      }

      return nil
      
    }

    @discardableResult
    func setTextColor(_ color: UIColor?)-> JJLabelUI{
        if color  != nil{
        self.attributedText = self.addAttribute(.foregroundColor, value: color!)
        
        }
    
      return self
    }



    @discardableResult
    func setTextAlignment(_ aligment: NSTextAlignment)-> JJLabelUI{
      self.setParagraphStyle(key: .alignment, value: aligment)
      return self
    }

    @discardableResult
    func setLineSpacing(_ spacing: CGFloat)-> JJLabelUI{
      self.setParagraphStyle(key: .lineSpacing, value: spacing)
      return self
    }
    
    @discardableResult
    private func setParagraphStyle(key: JJLabelUI.ParagraphStyleType,value: Any) -> NSMutableParagraphStyle?{
      
        if let at = self.attributedText?.mutableCopy() as? NSMutableAttributedString {
          
          if let ps =  at.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle{
              
              switch key {
              case .alignment :
                  ps.alignment = value as! NSTextAlignment
              case .lineSpacing:
                  ps.lineSpacing = value as! CGFloat
              }
              return ps
          }
      }
      
      return nil
    }

    @discardableResult
    func setFontUI(_ font: UIFont?)-> JJLabelUI{
      if font != nil{
          self.font = font
      }
      return self
      
    }
    @discardableResult
    func setAlpha(_ value: CGFloat)-> JJLabelUI{
        self.alpha = value < 0 ? 0 : value
      return self
    }


    @discardableResult
    func setTextColorUI(_ color: UIColor?)-> JJLabelUI{
      if color != nil{ self.textColor = color }
      return self
    }

    @discardableResult
    func setTextAlignmentUI(_ aligment: NSTextAlignment)-> JJLabelUI{
      self.textAlignment = aligment
      return self
    }
    @discardableResult
    open func setBackgroundColor(color: UIColor?)-> JJLabelUI{
      self.backgroundColor = color
      return self
    }


    @discardableResult
    func setBorder(width: CGFloat, color: UIColor) -> JJLabelUI {
      layer.borderWidth = width
      layer.borderColor = color.cgColor
      return self
    }


    @discardableResult
    func setCornerRadius(_ radius: CGFloat) -> JJLabelUI {
      layer.cornerRadius = radius
      return self
    }
    @discardableResult
    func setClipBounds(bool: Bool) ->JJLabelUI{
      self.clipsToBounds = bool
      return self
    }

    @discardableResult
    public func setClipShape(_ shape: JJLabelUI.TypeShape)-> JJLabelUI{
      self.shape = shape
      return self
    }


    private func makeShape(shape: JJLabelUI.TypeShape){
      switch shape {
      case .circle:
          self.layer.cornerRadius = min(self.bounds.height,self.bounds.width) / 2
      case .cornerVerySmall:
          self.layer.cornerRadius = min(self.bounds.height,self.bounds.width) * 0.03
      case .cornerSmall:
        self.layer.cornerRadius = min(self.bounds.height,self.bounds.width) * 0.05
      default:
          print("not implemented")
      }
      self.clipsToBounds = true
    }

    public enum TypeShape {
      case none, circle , cornerSmall, cornerVerySmall
    }

    public enum ParagraphStyleType {
      case alignment, lineSpacing
    }
    
    
    
    private var mConstraints : JJAnchoredConstraints = JJAnchoredConstraints()
    
    
    
    private func addAnchoredConstraints(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, margins: UIEdgeInsets? = nil,wAnchor: NSLayoutDimension? = nil, multiplierW: CGFloat = 1, hAnchor: NSLayoutDimension? = nil, multiplierH: CGFloat = 1, width: CGFloat = -1, height:CGFloat = -1, centerX: NSLayoutXAxisAnchor? = nil,constantX:CGFloat = 0, centerY:  NSLayoutYAxisAnchor? = nil, constantY:CGFloat = 0,priority: JJAnchoredPrioritys = JJAnchoredPrioritys.normal,text:String = "") {
        
        translatesAutoresizingMaskIntoConstraints = false
 
        if let top = top {
            mConstraints.top?.isActive = false
            mConstraints.top = topAnchor.constraint(equalTo: top, constant: margins?.top ?? 0)
            mConstraints.top?.priority = priority.top
              mConstraints.top?.identifier = "top"
        }
        
        if let leading = leading {
            mConstraints.leading?.isActive = false
            mConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: margins?.left ?? 0)
             mConstraints.leading?.priority = priority.leading
             mConstraints.leading?.identifier = "leading"
        }
        

        if let bottom = bottom {
             mConstraints.bottom?.isActive = false
            mConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -(margins?.bottom ?? 0))
              mConstraints.bottom?.priority = priority.bottom
        
        }
        
        if let trailing = trailing {
             mConstraints.trailing?.isActive = false
            mConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -(margins?.right ?? 0))
             mConstraints.trailing?.priority = priority.trailing
             mConstraints.trailing?.identifier = "trailing"
        }
        
        if width >= 0 {
                    mConstraints.width?.isActive = false
            mConstraints.width = widthAnchor.constraint(equalToConstant: width)
                 mConstraints.width?.priority = priority.width
                mConstraints.width?.identifier = "width"
             }
         
         if height >= 0 {
                    mConstraints.height?.isActive = false
             mConstraints.height = heightAnchor.constraint(equalToConstant: height)
             mConstraints.height?.priority = priority.height
              mConstraints.height?.identifier = "height"
         }
        
        if let wa = wAnchor {
                     mConstraints.width?.isActive = false
            mConstraints.width = widthAnchor.constraint(equalTo: wa, multiplier: multiplierW)
             mConstraints.width?.priority = priority.width
            mConstraints.width?.identifier = "width"
        }
        
        if let ha = hAnchor {
                   mConstraints.height?.isActive = false
            mConstraints.height = heightAnchor.constraint(equalTo: ha, multiplier: multiplierH)
             mConstraints.height?.priority = priority.height
                mConstraints.height?.identifier = "height"
        }
        
        if let centerx = centerX {
               mConstraints.centerXanchor?.isActive = false
            mConstraints.centerXanchor = centerXAnchor.constraint(equalTo: centerx, constant: constantX)
            mConstraints.centerXanchor?.priority = priority.centerX
             mConstraints.centerXanchor?.identifier = "centerX"
        }
        
        if let centery = centerY {
              mConstraints.centerYanchor?.isActive = false
            mConstraints.centerYanchor = centerYAnchor.constraint(equalTo: centery, constant: constantY)
            mConstraints.centerYanchor?.priority = priority.centerY
             mConstraints.centerYanchor?.identifier = "centerY"
        }
                
    
    }
    
    @discardableResult
    func clApply() -> JJLabelUI{
        [mConstraints.top, mConstraints.leading, mConstraints.bottom, mConstraints.trailing, mConstraints.width, mConstraints.height,
            mConstraints.centerXanchor,
            mConstraints.centerYanchor].forEach{
               $0?.isActive = true }
        
        return self
    }
    
    @discardableResult
     func clMargins(values: UIEdgeInsets) -> JJLabelUI{
         mConstraints.top?.constant = values.top
         mConstraints.bottom?.constant = -values.bottom
         mConstraints.leading?.constant = values.left
         mConstraints.trailing?.constant = -values.right
         return self
      }
     
    
    @discardableResult
    func clFillParent(margin:UIEdgeInsets = UIEdgeInsets(), priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
        
        guard let superviewTopAnchor = superview?.topAnchor,
                 let superviewBottomAnchor = superview?.bottomAnchor,
                 let superviewLeadingAnchor = superview?.leadingAnchor,
                 let superviewTrailingAnchor = superview?.trailingAnchor else {
                     return self
             }
        addAnchoredConstraints(top:superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, margins: margin, priority: priority)
        
        return self
    }
    
    @discardableResult
    func clFillParentHorizontally(startMargin: CGFloat = 0,endMargin:CGFloat = 0,_ priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
           
           guard let superviewLeadingAnchor = superview?.leadingAnchor,
                let superviewTrailingAnchor = superview?.trailingAnchor else {
                        return self
                }
        addAnchoredConstraints(top:nil, leading: superviewLeadingAnchor, bottom: nil, trailing: superviewTrailingAnchor, margins: UIEdgeInsets(top: 0,left: startMargin,bottom: 0,right: endMargin),priority: priority)
           
           return self
    }
    
    @discardableResult
    func clFillParentVertically(topMargin: CGFloat = 0,bottomMargin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
           
           guard let superviewTop = superview?.topAnchor,
                let superviewBottom = superview?.bottomAnchor else {
                        return self
                }
        addAnchoredConstraints(top:superviewTop, leading: nil, bottom: superviewBottom, trailing: nil, margins: UIEdgeInsets(top: topMargin,left: 0,bottom: bottomMargin,right: 0),priority: priority)
           
           return self
    }
    
    @discardableResult
    func clCenterInParent(constantX: CGFloat = 0, constantY: CGFloat = 0,priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{

         guard let superviewCenterX = superview?.centerXAnchor ,
                  let superviewCenterY = superview?.centerYAnchor
             else { return self }
        
        addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: nil, margins: nil,centerX: superviewCenterX,constantX: constantX,centerY: superviewCenterY,constantY: constantY, priority: priority)
         
         return self
     }
    
    @discardableResult
    func clCenterInParentHorizontally(constantX: CGFloat = 0,priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{

            guard let superviewCenterX = superview?.centerXAnchor
                else { return self }
           
           addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: nil,centerX: superviewCenterX,constantX: constantX, priority: priority)
            
            return self
     }
    
     @discardableResult
     func clCenterInParentVertically(constantY: CGFloat = 0,priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{

                guard let superviewCenterY = superview?.centerYAnchor
                    else { return self }
               
               addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: nil,centerY: superviewCenterY,constantY: constantY, priority: priority)
                
            return self
     }
    
   
    @discardableResult
    func clTopToTopParent( margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
          
          guard let superviewTopAnchor = superview?.topAnchor
                  else { return self }
        
        addAnchoredConstraints(top:superviewTopAnchor, leading: nil, bottom: nil, trailing: nil, margins: UIEdgeInsets.top(margin), priority: priority)
          
          return self
    }
    
    @discardableResult
    func clBottomToBottomParent( margin:CGFloat = 0,priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
        
        guard let sideAnchor = superview?.bottomAnchor
                else { return self }
      
      
      addAnchoredConstraints(top:nil, leading: nil, bottom: sideAnchor, trailing: nil, margins: UIEdgeInsets.bottom(margin), priority: priority,text: "soy botoom")
        
        return self
    }
    
    @discardableResult
    func clStartToStartParent( margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
           
           guard let sideAnchor = superview?.leadingAnchor
                   else { return self }
         
         addAnchoredConstraints(top:nil, leading: sideAnchor, bottom: nil, trailing: nil, margins: UIEdgeInsets.left(margin), priority: priority)
           
           return self
    }
    
    @discardableResult
    func clEndToEndParent( margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
           
           guard let sideAnchor = superview?.trailingAnchor
                   else { return self }
         
         addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: sideAnchor, margins: UIEdgeInsets.right(margin), priority: priority)
           
           return self
    }
    
    @discardableResult
       func clTopToBottomParent( margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
             
             guard let sideAnchor = superview?.bottomAnchor
                     else { return self }
           
           addAnchoredConstraints(top:sideAnchor, leading: nil, bottom: nil, trailing: nil, margins: UIEdgeInsets.top(margin), priority: priority)
             
             return self
       }
       
       @discardableResult
       func clBottomToTopParent( margin:CGFloat = 0,priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
           
           guard let sideAnchor = superview?.topAnchor
                   else { return self }
         
         addAnchoredConstraints(top:nil, leading: nil, bottom: sideAnchor, trailing: nil, margins: UIEdgeInsets.bottom(margin), priority: priority,text: "soy botoom")
           
           return self
       }
       
       @discardableResult
       func clStartToEndParent( margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
              
              guard let sideAnchor = superview?.trailingAnchor
                      else { return self }
            
            addAnchoredConstraints(top:nil, leading: sideAnchor, bottom: nil, trailing: nil, margins: UIEdgeInsets.left(margin), priority: priority)
              
              return self
       }
       
       @discardableResult
       func clEndToStartParent( margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
              
              guard let sideAnchor = superview?.leadingAnchor
                      else { return self }
            
            addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: sideAnchor, margins: UIEdgeInsets.right(margin), priority: priority)
              
              return self
       }
    
    
    @discardableResult
    func clWidth(size:CGFloat, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
            
        if size < 0 { return self }
          
        addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: nil, margins: nil,width: size, priority: priority)
            
            return self
     }
    @discardableResult
    func clHeight(size:CGFloat, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
            
        if size < 0 { return self }
          
        addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: nil, margins: nil,height: size, priority: priority)
            
            return self
    }

    
    @discardableResult
    func clWidthEqualTo(anchor:NSLayoutDimension,multiplier: CGFloat, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
               
             
        addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: nil, margins: nil,wAnchor: anchor, multiplierW: multiplier, priority: priority)
               
               return self
        }
    @discardableResult
    func clHeightEqualTo(anchor: NSLayoutDimension,multiplier: CGFloat, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
               

           addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: nil, margins: nil,hAnchor: anchor,multiplierH: multiplier, priority: priority)
               
               return self
    }
    
    @discardableResult
      func clWidthLessEqualTo(size:CGFloat, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
                
            if size < 0 { return self }
          mConstraints.width?.isActive = false
          mConstraints.width = widthAnchor.constraint(lessThanOrEqualToConstant: size)
          mConstraints.width?.identifier = "width"
          mConstraints.width?.priority = priority.width
                return self
      }
      
      @discardableResult
        func clHeightLessEqualTo(size:CGFloat, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
                  
              if size < 0 { return self }
            mConstraints.height?.isActive = false
            mConstraints.height = heightAnchor.constraint(lessThanOrEqualToConstant: size)
            mConstraints.height?.identifier = "height"
            mConstraints.height?.priority = priority.height
                  return self
        }
    
    @discardableResult
      func clWidthGreaterEqualTo(size:CGFloat, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
                
            if size < 0 { return self }
          mConstraints.width?.isActive = false
          mConstraints.width = widthAnchor.constraint(greaterThanOrEqualToConstant: size)
          mConstraints.width?.identifier = "width"
          mConstraints.width?.priority = priority.width
                return self
      }
      
      @discardableResult
        func clHeightGreaterEqualTo(size:CGFloat, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
                  
              if size < 0 { return self }
            mConstraints.height?.isActive = false
            mConstraints.height = heightAnchor.constraint(greaterThanOrEqualToConstant: size)
            mConstraints.height?.identifier = "height"
            mConstraints.height?.priority = priority.height
                  return self
        }
    
    @discardableResult
    func clTopToTopOf(view:UIView, margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
            
        addAnchoredConstraints(top:view.topAnchor, leading: nil, bottom: nil, trailing: nil, margins: UIEdgeInsets.top(margin), priority: priority)
            
            return self
      }
      
      @discardableResult
    func clBottomToBottomOf(view:UIView, margin:CGFloat = 0,priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{

        addAnchoredConstraints(top:nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, margins: UIEdgeInsets.bottom(margin), priority: priority,text: "soy botoom")
          
          return self
      }
      
      @discardableResult
    func clStartToStartOf(view: UIView, margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
           addAnchoredConstraints(top:nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, margins: UIEdgeInsets.left(margin), priority: priority)
             
             return self
      }
      
      @discardableResult
    func clEndToEndOf(view:UIView, margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
        
           addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, margins: UIEdgeInsets.right(margin), priority: priority)
             
             return self
      }
    
    
    
    @discardableResult
    func clTopToBottomOf(view:UIView, margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
            
        addAnchoredConstraints(top:view.bottomAnchor, leading: nil, bottom: nil, trailing: nil, margins: UIEdgeInsets.top(margin), priority: priority)
            
            return self
      }
      
      @discardableResult
    func clBottomToTopOf(view:UIView, margin:CGFloat = 0,priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{

        addAnchoredConstraints(top:nil, leading: nil, bottom: view.topAnchor, trailing: nil, margins: UIEdgeInsets.bottom(margin), priority: priority,text: "soy botoom")
          
          return self
      }
      
      @discardableResult
    func clStartToEndOf(view: UIView, margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
        addAnchoredConstraints(top:nil, leading: view.trailingAnchor, bottom: nil, trailing: nil, margins: UIEdgeInsets.left(margin), priority: priority)
             
             return self
      }
      
      @discardableResult
    func clEndToStartOf(view:UIView, margin:CGFloat = 0, priority:JJAnchoredPrioritys = .normal) -> JJLabelUI{
        
           addAnchoredConstraints(top:nil, leading: nil, bottom: nil, trailing: view.leadingAnchor, margins: UIEdgeInsets.right(margin), priority: priority)
             
             return self
      }
    
 
    @discardableResult
    func clVerticalBiasCenter(value: CGFloat) -> JJLabelUI{
        mConstraints.centerYanchor?.constant = value
        return self
     }
    
    @discardableResult
    func clHotizontalBiasCenter(value: CGFloat) -> JJLabelUI{
           mConstraints.centerXanchor?.constant = value
           return self
    }
}
