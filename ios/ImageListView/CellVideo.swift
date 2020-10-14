//
//  CellVideo.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/18/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit
import MediaPlayer

class CellVideo: UICollectionViewCell,SelectableProtocol {
    
    
    private var mImageView = GuisoView()
    private let mImageSelectable = SelectableView()
    private let mContainerLabel = UIView()
    private let mLabelDuration = UILabel()
    private let mImageVideoIcon = UIImageView()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
    
      
    }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mImageView.getRequest()?.cancel()
        mImageView.onHolder(nil)
    }
    
    @discardableResult
    func setBackgroundColor(_ color:UIColor) -> CellVideo{
        mImageView.backgroundColor = color
        return self
    }
    
    @discardableResult
    func setColorAccent(_ color:UIColor) -> CellVideo{
        mImageSelectable.setColorAccent(color)
        return self
    }
    
   
    @discardableResult
    func setColorAccent(_ color:UIColor?) -> CellVideo{
        mImageSelectable.setColorAccent(color)
        return self
    }
    
    @discardableResult
    func isSelectableIconVisible(_ bool:Bool) ->CellVideo{

        self.mImageSelectable.isHidden = !bool
        
      
        return self
    }
    
    @discardableResult
    func setScaleType(_ st:Int) -> CellVideo{
        mImageView.contentMode = st == 1 ? .scaleAspectFit : .scaleAspectFill
        return self
    }
    
    func isSelected(_ bool: Bool) {
        mImageSelectable.isSelected(bool)
    }
    
    @discardableResult
    func setDuration(_ millis:Int64) -> CellVideo{
        mLabelDuration.text = millisSegToTimeString(millis)
        return self
    }
    
    @discardableResult
    func isVideoIconVisible(_ vis:Bool) -> CellVideo{
        mImageVideoIcon.isHidden = !vis
        return self
    }
    
    
    private func millisSegToTimeString(_ time:Int64) -> String {
        var seconds = 0
        var minutes = 0
        var hours = 0
        if time >= 1000 {
            seconds = Int(time / 1000)
            if seconds > 60 {
                minutes = seconds / 60
                seconds %= 60
                if minutes > 60 {
                    hours = minutes / 60
                    minutes %= 60
                }
            }
        }
        
        let secondString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        
        return hours > 0 ? "\(hoursString):\(minutesString):\(secondString)"
        :"\(minutesString):\(secondString)"
    }
  
    @discardableResult
    func applyMargin(_ l:Int,t:Int,b:Int,r:Int) -> CellVideo{
        mTopAnchor?.constant = CGFloat(t)
        mBottomAnchor?.constant = CGFloat(t)
        mLeadingAnchor?.constant = CGFloat(t)
        mTrailingAnchor?.constant = CGFloat(t)
        return self
    }
    
    
    var mTopAnchor : NSLayoutConstraint?
    var mBottomAnchor : NSLayoutConstraint?
    var mLeadingAnchor : NSLayoutConstraint?
    var mTrailingAnchor : NSLayoutConstraint?
    private func setupViews() {
       addSubview(mImageView)
        addSubview(mImageSelectable)
        addSubview(mContainerLabel)
        addSubview(mImageVideoIcon)
        mContainerLabel.addSubview(mLabelDuration)
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
        mImageSelectable.widthAnchor.constraint(equalToConstant: JJScreen.point(p: 20)).isActive = true
        mImageSelectable.heightAnchor.constraint(equalToConstant: JJScreen.point(p: 20)).isActive = true
        
        
        //duration
        
        mLabelDuration.text = "00:00"
        mLabelDuration.font = mLabelDuration.font.withSize(12)
        mLabelDuration.textColor = UIColor.white
        mContainerLabel.clipsToBounds = true
        mContainerLabel.backgroundColor = UIColor.parseColor("#80262626")
        mContainerLabel.translatesAutoresizingMaskIntoConstraints = false
        mContainerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        mContainerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        mLabelDuration.translatesAutoresizingMaskIntoConstraints = false
        mLabelDuration.trailingAnchor.constraint(equalTo: mContainerLabel.trailingAnchor, constant: -4).isActive = true
        mLabelDuration.bottomAnchor.constraint(equalTo: mContainerLabel.bottomAnchor, constant: -2).isActive = true
        mLabelDuration.topAnchor.constraint(equalTo: mContainerLabel.topAnchor, constant: 2).isActive = true
        mLabelDuration.leadingAnchor.constraint(equalTo: mContainerLabel.leadingAnchor, constant: 4).isActive = true
        
        
        //video
        
        mImageVideoIcon.translatesAutoresizingMaskIntoConstraints = false
        mImageVideoIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        mImageVideoIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        mImageVideoIcon.widthAnchor.constraint(equalToConstant: 15).isActive = true
        mImageVideoIcon.heightAnchor.constraint(equalToConstant: 15).isActive = true
        mImageVideoIcon.contentMode = .scaleAspectFit
        let frameworkBundle = Bundle(for: CellVideo.self)
        let bundleURL = frameworkBundle.url(forResource: "jjkitbundle", withExtension: "bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        mImageVideoIcon.image = UIImage(named: "video",in: resourceBundle, compatibleWith: nil)
        
    }
    
  
    override func layoutSubviews() {
        super.layoutSubviews()
        let r = min(mLabelDuration.bounds.width,mContainerLabel.bounds.height) / 2
        mContainerLabel.layer.cornerRadius = r
    }
    
    func getImageView()-> GuisoView{
        return mImageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
