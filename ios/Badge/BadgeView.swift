
import UIKit

@objc(BadgeView)
class BadgeView : UIView {
    
    private var mText = NSMutableAttributedString(string: "99+")
    private var mTextSize : CGFloat = 15
    private var mFont = UIFont.systemFont(ofSize: 15)
    private var mTextColor = UIColor.black
    private var mIsTextHidden = false
   
        
    public init() { super.init(frame:.zero)
         backgroundColor = UIColor.clear
    }
    required public init?(coder aDecoder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
    }
    //code
     override var bounds: CGRect {
         didSet{ makeShape() }
     }
     

   
     @objc func setText(_ text:String?){
           mText.mutableString.setString((text ?? "99+"))
           setNeedsDisplay()
     }
     
      @objc func setTextSize(_ size : CGFloat) {
           mTextSize = size < 0 ? 0 : size
           setNeedsDisplay()
      }
     
 
     @objc func setFont(_ name: String?){
         mFont = name == nil ? UIFont.systemFont(ofSize: 15) :  UIFont(name: name!, size: 15)!
            setNeedsDisplay()
     }
   
     
      @objc func setTextColor(_ color: String?){
       mTextColor = color == nil ? UIColor.black  : UIColor.parseColor(color!)!
           setNeedsDisplay()
       
     }
     
  
      @objc func setIsTextHidden(_ boolean: Bool){
            mIsTextHidden = boolean
          setNeedsDisplay()
     }
     
     private var mTextOffsetX : CGFloat = 0
      @objc func setTextOffsetX(_ value: CGFloat){
          mTextOffsetX = value
          setNeedsDisplay()
     }
   
     private var mTextOffsetY : CGFloat = 0
      @objc func setTextOffsetY(_ value: CGFloat){
            mTextOffsetY = value
          setNeedsDisplay()
       
     }
   
     @objc func setStrokeColor(_ color: String?){
      layer.borderColor = color == nil ? UIColor.black.cgColor :  UIColor.parseColor(color!)!.cgColor
  
     }
     @objc func setStrokeWidth(_ value: CGFloat) {
         layer.borderWidth = value
    
     }
   
    @objc func setInsetX(_ value: CGFloat){
        setNeedsDisplay()
     }
     
    @objc func setInsetY(_ value: CGFloat){
        setNeedsDisplay()
    }
   
   override func didSetProps(_ changedProps: [String]!) {}
      
     private var mDeltaY = 0
     private var mDeltaX = 0
     private var mBoundsText = CGSize(width: 0, height: 0)
     override func draw(_ rect: CGRect) {
         super.draw(rect)
       mFont = mFont.withSize(mTextSize)
       mText.addAttributes([.font: mFont,
                            .foregroundColor: mTextColor], range: NSRange(location: 0, length: self.mText.length))
         mText.sizeOneLine(cgSize: &mBoundsText)
         let deltaY =  ( bounds.height / 2 - mBoundsText.height / 2 ) + mTextOffsetY
         let deltaX = ( bounds.width / 2 - mBoundsText.width / 2 ) + mTextOffsetX
         if(!mIsTextHidden) { self.mText.draw(at: CGPoint(x: deltaX,y: deltaY)) }
     }

     private func makeShape(){
        self.layer.cornerRadius = min(self.bounds.height,self.bounds.width) / 2
       self.clipsToBounds = true
     }

   

}



