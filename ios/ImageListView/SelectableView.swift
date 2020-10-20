//
//  SelectableView.swift
//  AnimationPractica
//
//  Created by Juan J LF on 10/11/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit

class SelectableView: UIView{
    
    private var mColorAccent : UIColor? = UIColor.systemPurple
    private let mImageView = UIImageView()

    convenience init(_ color:UIColor?){
        self.init(frame: .zero)
        mColorAccent = color
    }
    
    private var mTopAnchor: NSLayoutConstraint?
    private var mBottomAnchor: NSLayoutConstraint?
    private var mLeadingAnchor: NSLayoutConstraint?
    private var mTrailingAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        clipsToBounds = true
        layer.borderColor = UIColor.white.cgColor
        
        backgroundColor = UIColor.parseColor("#40FFFFFF")
        addSubview(mImageView)
        mImageView.translatesAutoresizingMaskIntoConstraints = false
        mTopAnchor =  mImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        mTopAnchor?.isActive = true
        mBottomAnchor = mImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        mBottomAnchor?.isActive = true
        mLeadingAnchor = mImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        mLeadingAnchor?.isActive = true
        mTrailingAnchor = mImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        mTrailingAnchor?.isActive = true
        mImageView.contentMode = .scaleAspectFit
    }
    
    
    override var bounds: CGRect{
        didSet{
            let m = min(bounds.width, bounds.height)
           let r =  m / 2
            layer.borderWidth = m * 0.1
            layer.cornerRadius = r
            let margin = m * 0.26
            mTopAnchor?.constant = margin
            mBottomAnchor?.constant = -margin
            mLeadingAnchor?.constant = margin
            mTrailingAnchor?.constant = -margin
        }
    }
    
    @discardableResult
    func setColorAccent(_ color:UIColor?)->SelectableView{
        mColorAccent = color
        return self
    }
    
    @discardableResult
    func setBorderWidth(_ w: CGFloat)->SelectableView{
        layer.borderWidth = w
        return self
    }
    
    @discardableResult
    func isSelected(_ bool: Bool)->SelectableView{
        if(bool){
                        
            let frameworkBundle = Bundle(for: SelectableView.self)
            let bundleURL = frameworkBundle.url(forResource: "jjkitbundle", withExtension: "bundle")
            let resourceBundle = Bundle(url: bundleURL!)
            mImageView.image = UIImage(named: "done",in: resourceBundle, compatibleWith: nil)
            backgroundColor = mColorAccent
        }else{
            mImageView.image = nil
            backgroundColor = UIColor.parseColor("#40FFFFFF")
        }
        return self
    }

    convenience init(){
        self.init(frame:.zero)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
