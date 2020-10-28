//
//  ImageList.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 10/9/20.
//

import UIKit

@objc(ImageList)
class ImageList : UIView, MediaCollectionListener{
    
 
    
 
    

    private var mIsSelectable = false
    @objc var onEndReached : RCTDirectEventBlock?
    @objc var onItemClicked : RCTDirectEventBlock?
    
    let mMediaCollection = MediaCollectionView()
    
   
    @objc func setSource(_ source:[String:Any]?){
        let list = source?["data"] as? [[String:Any?]?] ?? [[String:Any?]?]()
        
        let options = source?["options"] as? [String:Any?]
        let resize = source?["resize"] as? [String:Any?]
        let cell = source?["cell"] as? [String:Any?]
        
        mIsSelectable = options?["selectable"] as? Bool ?? false
        //options
        
        
        mMediaCollection.setSpanCount(options?["spanCount"] as? Int ?? 3)
            .setOrientation(options?["orientation"] as? String ?? MediaCollectionView.VERTICAL)
            .isSelectable(mIsSelectable)
            .setSelectableColor(UIColor.parseColor(options?["selectableColor"] as? String ?? "#262626")!)
            .isVideoIconVisible(options?["videoIconVisible"] as? Bool ?? true)
            .isDurationIconVisible(options?["durationVisible"] as? Bool ?? true)
            .isProgressVisible(options?["progressVisible"] as? Bool ?? false)
            .setProgressSize(options?["progressSize"] as? CGFloat ?? 60)
            .setProgressColor(UIColor.parseColor(options?["progressColor"] as? String ?? "#262626")!)
            .setAllowGif(options?["allowGif"] as? Bool ?? false)
            .setThreshold(options?["threshold"] as? Int ?? 2)
        
        
            .setDurationTextSize(options?["durationTextSize"] as? CGFloat ?? 11)
            .setVideoIconSize(options?["videoIconSize"] as? CGFloat ?? 14)
            .setProgressCellSize(options?["progressCellSize"] as? CGFloat ?? 60)
            .setSelectableIconSize(options?["selectableIconSize"] as? CGFloat ?? 12)
        
        //resize
        
        mMediaCollection.setResizeOptions(resize?["width"] as? Int ?? 300, h: resize?["height"] as? Int ?? 300, rm: resize?["mode"] as? String ?? MediaCollectionView.RESIZE_MODE_COVER)
        
        //cell
        
        let margin = cell?["margin"] as? [String:Any?] ?? [String:Any]()
        
        let m = JJMargin()
        m.top = margin["top"] as? CGFloat ?? 0
        m.left = margin["left"] as? CGFloat ?? 0
        m.bottom = margin["bottom"] as? CGFloat ?? 0
        m.right = margin["right"] as? CGFloat ?? 0
        
        mMediaCollection.setCellOptions(cell?["size"] as? Int ?? Int(JJScreen.width / 3), bgColor: UIColor.parseColor(cell?["backgroundColor"] as? String ?? "#cccccc")!)
            .setScaleType(cell?["scaleType"] as? String ?? MediaCollectionView.SCALE_TYPE_COVER)
            .setMargin(m)
        
        mMediaCollection.newData(list)
    }
    
    
 
  
    func onItemClicked(position: Int, view: CellPhoto) {
       
        onItemClicked?(["item" : mMediaCollection.getItems()[position]!])
    }
    
    func onItemClicked(position: Int, view: CellVideo) {
       
        onItemClicked?(["item" : mMediaCollection.getItems()[position] ?? [String:Any]()])
    }
    func endReached() {
        onEndReached?([String:Any]())
    }
    

    
    convenience init(){
        self.init(frame: .zero)
        addSubview(mMediaCollection)
        mMediaCollection.setListener(self)
        mMediaCollection.translatesAutoresizingMaskIntoConstraints = false
        mMediaCollection.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        mMediaCollection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        mMediaCollection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        mMediaCollection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    
}
