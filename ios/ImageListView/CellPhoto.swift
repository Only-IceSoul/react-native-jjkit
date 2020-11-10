//
//  CellPhoto.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/18/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit
import JJGuiso

class CellPhoto: UICollectionViewCell,SelectableProtocol {
  
   
    
    
    private var mImageView = GuisoView()
    private let mImageSelectable = SelectableView()
    
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
      
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Guiso.clear(target: mImageView)
    }
  
    @discardableResult
    func setBackgroundColor(_ color:UIColor) -> CellPhoto{
        mImageView.backgroundColor = color
        return self
    }
    
    @discardableResult
    func setColorAccent(_ color:UIColor) -> CellPhoto{
        mImageSelectable.setColorAccent(color)
        return self
    }
    
   
    @discardableResult
    func setColorAccent(_ color:UIColor?) -> CellPhoto{
        mImageSelectable.setColorAccent(color)
        return self
    }
    
    @discardableResult
    func isSelectableIconVisible(_ bool:Bool) ->CellPhoto{

        self.mImageSelectable.isHidden = !bool
        
      
        return self
    }
    
    @discardableResult
    func setScaleType(_ st:Int) -> CellPhoto{
        mImageView.contentMode = st == 1 ? .scaleAspectFit : .scaleAspectFill
        return self
    }
    
    func isSelected(_ bool: Bool) {
        mImageSelectable.isSelected(bool)
      
    }

  
    @discardableResult
    func applyMargin(_ l:Int,t:Int,b:Int,r:Int) -> CellPhoto{
        mTopAnchor?.constant = CGFloat(t)
        mBottomAnchor?.constant = CGFloat(t)
        mLeadingAnchor?.constant = CGFloat(t)
        mTrailingAnchor?.constant = CGFloat(t)
        return self
    }
    
    private var mSelectableIconWidth :NSLayoutConstraint?
    private var mSelectableIconHeight :NSLayoutConstraint?
    @discardableResult
    func setSelectableIconSize(size: CGFloat)->CellPhoto{
        mSelectableIconWidth?.isActive = false
        mSelectableIconHeight?.isActive = false
        mSelectableIconWidth = mImageSelectable.widthAnchor.constraint(equalToConstant: size)
        mSelectableIconHeight = mImageSelectable.heightAnchor.constraint(equalToConstant: size)
        mSelectableIconWidth?.isActive = true
        mSelectableIconHeight?.isActive = true
        return self
    }
    
    
    var mTopAnchor : NSLayoutConstraint?
    var mBottomAnchor : NSLayoutConstraint?
    var mLeadingAnchor : NSLayoutConstraint?
    var mTrailingAnchor : NSLayoutConstraint?
    private func setupViews() {
       addSubview(mImageView)
        addSubview(mImageSelectable)
        mImageView.contentMode = .scaleAspectFill
        mImageView.translatesAutoresizingMaskIntoConstraints = false
        mTopAnchor =  mImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        mTopAnchor?.isActive = true
        mBottomAnchor =  mImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        mBottomAnchor?.isActive = true
        mLeadingAnchor =  mImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        mLeadingAnchor?.isActive = true
        mTrailingAnchor =  mImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        mTrailingAnchor?.isActive = true
        
        mImageSelectable.translatesAutoresizingMaskIntoConstraints = false
        
        mImageSelectable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        mImageSelectable.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        mSelectableIconWidth =  mImageSelectable.widthAnchor.constraint(equalToConstant: 11)
        mSelectableIconWidth?.isActive = true
        mSelectableIconHeight = mImageSelectable.heightAnchor.constraint(equalToConstant: 11)
        mSelectableIconHeight?.isActive = true
        
    }
    
  
    
    func getImageView()-> GuisoView{
        return mImageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}
