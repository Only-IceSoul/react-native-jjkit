//
//  ProgressCell.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 10/9/20.
//

import UIKit

class ProgressCell : UICollectionViewCell{
        
    let progress = ProgressView()
    
  
    func setProgressSize(size:CGFloat){
        mWidthAnchor?.isActive = false
        mHeightAnchor?.isActive = false
        mWidthAnchor =  progress.widthAnchor.constraint(equalToConstant: size )
        mHeightAnchor = progress.heightAnchor.constraint(equalToConstant:size)
        mWidthAnchor?.isActive = true
        mHeightAnchor?.isActive = true
    }
    
    func setColor(_ color:UIColor){
        progress.setColor(color)
    }
    
    private var mWidthAnchor:NSLayoutConstraint?
    private var mHeightAnchor:NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mWidthAnchor =  progress.widthAnchor.constraint(equalToConstant: 60 )
        mHeightAnchor = progress.heightAnchor.constraint(equalToConstant:60)
        mWidthAnchor?.isActive = true
        mHeightAnchor?.isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
