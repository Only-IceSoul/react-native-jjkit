//
//  GuisoView.swift
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit


public class GuisoView: UIImageView , ViewTarget {
   
    
    
    init(){
        super.init(frame: .zero)
        clipsToBounds = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        clipsToBounds = true
    }
    
    
    public func onFallback() {
      
    }
    
    //error, placeholder, fallback
    public func onHolder(_ image: UIImage?) {
        removeGif()
        self.image = image
    }
 
    
    private var mGif: AnimatedLayer?
    override public var bounds: CGRect{
        didSet{
            mGif?.onBoundsChange(bounds)
        }
    }
    
    public func onResourceReady(_ gif: AnimatedLayer) {
        image = nil
        removeGif()
        addGif(gif)
    }
    
    public func onResourceReady(_ img: UIImage) {
        removeGif()
        image = img
    }
    
    public func onThumbReady(_ img: UIImage?) {
        //if thumb fail and error thumb fail  img is nil.
            removeGif()
            image = img
        
    }
    
    public func onThumbReady(_ gif: AnimatedLayer) {
        image = nil
        removeGif()
        addGif(gif)
       
    }
    
    public func onLoadFailed(_ error:String) {
        // auto retry?
        //show clickview and let user retry?
        print("Load failed ",error )
    }
  
    
    private var mRequest: GuisoRequest?
    public func setRequest(_ tag:GuisoRequest?) {
        mRequest = tag
    }
    public func getRequest() -> GuisoRequest?{
        return mRequest
    }
   

    public func getContentMode() -> UIView.ContentMode {
        return self.contentMode
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.width > 0 && bounds.height > 0 && mGif?.isAnimating() == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.mGif?.startAnimation()
            }
        }
    }
    
    private func removeGif(){
        mGif?.removeFromSuperlayer()
        mGif = nil
    }
    
    private func addGif(_ gif:AnimatedLayer){
        mGif = gif
        mGif?.setContentMode(self.contentMode)
        layer.addSublayer(mGif!)
        mGif?.onBoundsChange(bounds)
    }

}
