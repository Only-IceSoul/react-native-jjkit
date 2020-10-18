//
//  File.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/18/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit
import Photos

class MediaCollectionView: UICollectionView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    
    //constants
    
    static let VERTICAL = "vertical"
    static let HORIZONTAL = "horizontal"
    static let RESIZE_MODE_COVER = "cover"
    static let RESIZE_MODE_CONTAIN = "contain"
    static let SCALE_TYPE_COVER = "cover"
    static let SCALE_TYPE_CONTAIN = "contain"
    
  
    weak var parenController : UIViewController?
    
    private let VERTICAL = 1
    private let HORIZONTAL = 0
    
    private let cellIdPhoto = "cellPhoto"
    private let cellIdVideo = "cellVideo"
    private let cellIdFooter = "cellFooter"
    
    private var mItems = [[String:Any?]?]()
    
    private var mShowProgressView = false
    private var mProgressSize:CGFloat = 60
    private var mProgressColor = UIColor.parseColor("#262626")
    private var mSelectableColor = UIColor.parseColor("#262626")
 
    private var mIsVideoIconVisible = true
    private var mIsDurationIconVisible = true

    private weak var mOnItemClickedListener:MediaCollectionListener?
    private var mLayoutManager : UICollectionViewFlowLayout!
    convenience init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.init(frame: .zero,collectionViewLayout:layout)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        mLayoutManager = layout as? UICollectionViewFlowLayout
        super.init(frame: frame, collectionViewLayout: layout)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(CellPhoto.self, forCellWithReuseIdentifier: cellIdPhoto)
        register(CellVideo.self, forCellWithReuseIdentifier: cellIdVideo)
        register(ProgressCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: cellIdFooter)
    }
    
    private var mSpanCount = 3
    @discardableResult
    func setSpanCount(_ sc:Int)-> MediaCollectionView{
        mSpanCount = sc
        return self
    }
    
    private var mScaleType = MediaCollectionView.SCALE_TYPE_COVER
    @discardableResult
    func setScaleType(_ sc:String)->MediaCollectionView{
        mScaleType = sc
        return self
    }
    private var mThreshold = 2
    @discardableResult
    func setThreshold(_ tr:Int)->MediaCollectionView{
        mThreshold = tr
        return self
    }
    private var mMargin = JJMargin()
    @discardableResult
    func setMargin(_ m:JJMargin)->MediaCollectionView{
        mMargin = m
        return self
    }
    @discardableResult
    func setProgressColor(_ color:UIColor)-> MediaCollectionView{
        mProgressColor = color
        return self
    }
    
    @discardableResult
    func setSelectableColor(_ color:UIColor)-> MediaCollectionView{
        mSelectableColor = color
        return self
    }
 
    @discardableResult
    func setListener(_ listener:MediaCollectionListener)-> MediaCollectionView{
        mOnItemClickedListener = listener
        return self
    }
    
    @discardableResult
    func setProgressSize(_ size:CGFloat)-> MediaCollectionView{
        mProgressSize = size
        return self
    }
    
    @discardableResult
    func isProgressVisible(_ bool:Bool)-> MediaCollectionView{
        mShowProgressView = bool
        return self
    }
    @discardableResult
    func isVideoIconVisible(_ bool:Bool)-> MediaCollectionView{
        mIsVideoIconVisible = bool
        return self
    }
    
    @discardableResult
    func isDurationIconVisible(_ bool:Bool)-> MediaCollectionView{
        mIsDurationIconVisible = bool
        return self
    }
    
    private var mIsSelectable = false
    @discardableResult
    func isSelectable(_ bool:Bool)-> MediaCollectionView{
        mIsSelectable = bool
        return self
    }
    
    private var mAllowGif = false
    @discardableResult
    func setAllowGif(_ bool:Bool)-> MediaCollectionView{
        mAllowGif = bool
        return self
    }
    
    private var mOrientation = VERTICAL
    @discardableResult
    func setOrientation(_ o:String)-> MediaCollectionView{
        mOrientation = o
        mLayoutManager.scrollDirection = o == MediaCollectionView.HORIZONTAL ? .horizontal : .vertical
        return self
    }
    
    private var mWidth = 300
    private var mHeight = 300
    private var mResizeMode = MediaCollectionView.RESIZE_MODE_COVER
    @discardableResult
    func setResizeOptions(_ w:Int,h:Int,rm:String)-> MediaCollectionView{
        mWidth = w
        mHeight = h
        mResizeMode = rm
        return self
    }
    private var mSizeCell = 0
    private var mBackgroundColorCell = UIColor.white
    @discardableResult
    func setCellOptions(_ size:Int,bgColor:UIColor)-> MediaCollectionView{
        mSizeCell = size
        mBackgroundColorCell = bgColor
        return self
    }
    
    
    @discardableResult
    func newData(_ list: [[String:Any?]?]?) -> MediaCollectionView{
        mItems = list != nil ? list! : [[String:Any]?]()
        reloadData()
        scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        return self
    }
    
    
    @discardableResult
    func addItems(_ list: [[String:Any]?]?) -> MediaCollectionView{
        DispatchQueue.main.async {
            
            if(list != nil && list?.isEmpty == false){
                self.mItems.append(contentsOf: list!)
                self.reloadData()
            }else{
                if(self.mShowProgressView){
                    self.mShowProgressView = false
                    self.reloadData()
                }
            }
            
        }
        return self
    }
    
    func getItems() -> [[String:Any?]?]{
        return mItems
    }
    
    
    func getCountSelectedItems()->Int{
        var numberSelection = 0
        mItems.forEach { (i) in
            if(i != nil){
                numberSelection += (i?["isSelected"] as? Bool) == true ? 1 : 0
            }
            
        }
        return numberSelection
    }
    
       
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        
        if(mItems[indexPath.row]?["isSelected"] == nil){
            mItems[indexPath.row]?["isSelected"] = false
        }
        if(mItems[indexPath.row]?["mediaType"] == nil){
            mItems[indexPath.row]?["mediaType"] = "image"
        }
        if(mItems[indexPath.row]?["isEnabled"] == nil){
            mItems[indexPath.row]?["isEnabled"] = true
        }
    
        let item = mItems[indexPath.row]
    
        
        var g = ((item?["mediaType"] as? String) == "gif" && mAllowGif ) ? Guiso.load(model: item?["uri"] as? String).asGif() : Guiso.load(model: item?["uri"] as? String)
        
        if(mWidth > 0 && mHeight > 0 ){
            g = mResizeMode == MediaCollectionView.RESIZE_MODE_CONTAIN ? g.fitCenter().override(mWidth, mHeight) : g.centerCrop().override(mWidth, mHeight)
        }
        
        g = g.frame(0)
        
        let type = item?["mediaType"] as? String ?? "image"
        
         
         
        switch type {
        case "image","gif":
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdPhoto, for: indexPath) as! CellPhoto
            //bind
            cell.isSelected((item?["isSelected"] as? Bool) ?? false)
            cell.setColorAccent(self.mSelectableColor)
            cell.isSelectableIconVisible(mIsSelectable)
            JJLayout().clSetView(view: cell.getImageView())
                .clMargins(m: self.mMargin)
                .clDisposeView()
            
            cell.getImageView().backgroundColor = self.mBackgroundColorCell
            cell.getImageView().contentMode = self.mScaleType == MediaCollectionView.SCALE_TYPE_CONTAIN ? .scaleAspectFit : .scaleAspectFill
            g.into(cell.getImageView())
            
           
         
            return cell
           
        case "video":
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdVideo, for: indexPath) as! CellVideo
            
            cell.isSelected((item?["isSelected"] as? Bool) ?? false)
            cell.setColorAccent(self.mSelectableColor)
            cell.isSelectableIconVisible(mIsSelectable)
            JJLayout().clSetView(view: cell.getImageView())
                .clMargins(m: self.mMargin)
                .clDisposeView()
            
            cell.getImageView().backgroundColor = self.mBackgroundColorCell
            cell.getImageView().contentMode = self.mScaleType == MediaCollectionView.SCALE_TYPE_CONTAIN ? .scaleAspectFit : .scaleAspectFill
            
         
            //duration - iconvideo
            cell.setDuration(Int64((item?["duration"] as? Double ?? 0) * 1000.0))
                .isVideoIconVisible(item?["videoIconVisible"] as? Bool ?? true)
            g.into(cell.getImageView())
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let item = mItems[indexPath.row] else { return }
        let type = item["mediaType"] as? String ?? ""
        
      
        
        switch type {
        case "image":
            if mIsSelectable {   updateItemSelected(indexPath.row, collectionView.cellForItem(at: indexPath) as! CellPhoto)
            }
            mOnItemClickedListener?.onItemClicked(position: indexPath.row, view: collectionView.cellForItem(at: indexPath) as! CellPhoto)
            break
        case "video":
            if mIsSelectable {      updateItemSelected(indexPath.row, collectionView.cellForItem(at: indexPath) as! CellVideo)}
            mOnItemClickedListener?.onItemClicked(position: indexPath.row, view: collectionView.cellForItem(at: indexPath) as! CellVideo)
            break
        default:
            print("mediaType is not image or video")
        }
        
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let h =  self.mMargin.left + self.mMargin.right
        let v = self.mMargin.top + self.mMargin.bottom
        let size = mOrientation == MediaCollectionView.HORIZONTAL ?
            CGSize(width: CGFloat(mSizeCell) + h, height: collectionView.bounds.height /  CGFloat(mSpanCount))
        :CGSize(width: collectionView.bounds.width / CGFloat(mSpanCount), height: CGFloat(mSizeCell) + v)
        
        return size
    
    
     }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
       
          return 0
      }
    
      
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
          return 0
      }
    
    
    //footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        
        return mOrientation == MediaCollectionView.HORIZONTAL ?   .init(width: mShowProgressView ? mProgressSize : 0, height: collectionView.bounds.height ) :
            .init(width: collectionView.bounds.width, height: mShowProgressView ? mProgressSize : 0)
   }
    
    /// If you don't provide this, headers and footers for UICollectionViewControllers will be drawn above the scroll bar.
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        view.layer.zPosition = -1
    }
   
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
        if(mShowProgressView){
            mOnItemClickedListener?.endReached()
        }
      
        let f = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:cellIdFooter, for: indexPath) as! ProgressCell
        
        f.setColor(mProgressColor!)
        
        return f
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !mShowProgressView && !decelerate && isLastCellVisible()  {
            mOnItemClickedListener?.endReached()
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !mShowProgressView && isLastCellVisible() {
            mOnItemClickedListener?.endReached()
            
        }
    }
    

    
    private func isLastCellVisible()->Bool{
        let indexPath = IndexPath(item: mItems.count - 1, section: 0)
        guard let attrs = layoutAttributesForItem(at: indexPath)
                else {
                    return false
                }
        
        return boundsIntersect(bounds,attrs.frame)
    }
    
    private func isFotterVisible() -> Bool{
        let indexPath = IndexPath(item: 0, section: 0)
        guard let attrs = layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
                else {
                    return false
                }
        
        return boundsIntersect(bounds,attrs.frame)
    }
    
    private func boundsIntersect(_ bounds:CGRect,_ rect:CGRect)->Bool{
        return (bounds.origin.x < rect.origin.x + rect.size.width)
            && (rect.origin.x < bounds.origin.x + bounds.size.width)
            && (bounds.origin.y < rect.origin.y + rect.size.height)
            && (rect.origin.y < bounds.origin.y + bounds.size.height)
    }
   
    
    func updateItemSelected(_  position:Int,_ view:SelectableProtocol){
        
       
       let numberSelection = getCountSelectedItems()
      
     
        
        let st =  mItems[position]?["isSelected"] as? Bool ?? false
        
        
        if(mThreshold > 1){
            if(numberSelection - 1 == 0 && st) || (numberSelection < mThreshold - 1 || st) || (numberSelection == mThreshold - 1){
                mItems[position]?["isSelected"] = !st
                view.isSelected(!st)
            }
            
        }else{
            if(numberSelection == 0 || (numberSelection > 0 && st)){
                mItems[position]?["isSelected"] = !st
                view.isSelected(!st)
            }
        
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
protocol MediaCollectionListener : AnyObject {
    func onItemClicked(position: Int,view:CellPhoto)
    func onItemClicked(position: Int,view:CellVideo)
    func endReached()
}


