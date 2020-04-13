//
//  extension_UIView.swift
//  CreatingViewComponents
//
//  Created by Juan J LF on 3/4/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//
import UIKit

public struct JJAnchoredPrioritys {
     var top, bottom, leading, trailing, width, height, centerX, centerY : UILayoutPriority
    
    static let normal = JJAnchoredPrioritys(top: UILayoutPriority(rawValue: 950), bottom: UILayoutPriority(rawValue: 950), leading: UILayoutPriority(rawValue: 950), trailing: UILayoutPriority(rawValue: 950), width: UILayoutPriority(rawValue: 950), height: UILayoutPriority(rawValue: 950), centerX: UILayoutPriority(rawValue: 950), centerY: UILayoutPriority(rawValue: 950))
    
    static let required = JJAnchoredPrioritys(top: UILayoutPriority(rawValue: 1000), bottom: UILayoutPriority(rawValue: 1000), leading: UILayoutPriority(rawValue: 1000), trailing: UILayoutPriority(rawValue: 1000), width: UILayoutPriority(rawValue: 1000), height: UILayoutPriority(rawValue: 1000), centerX: UILayoutPriority(rawValue: 1000), centerY: UILayoutPriority(rawValue: 1000))
}

public class JJAnchoredConstraints {
     var top, leading, bottom, trailing, width, height, centerXanchor, centerYanchor: NSLayoutConstraint?
}

   
extension UIEdgeInsets {
    static public func all(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: side, bottom: side, right: side)
    }
    static public func top(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: 0, bottom: 0, right: 0)
    }
    
    static public func bottom(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: side, right: 0)
    }
    static public func left(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: side, bottom: 0, right: 0)
    }
    static public func right(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: side)
    }
    
}


extension UIWindow {
    static var key: UIWindow? {
               if #available(iOS 13, *) {
                    let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                    
                return keyWindow
                
               } else {
                   return UIApplication.shared.keyWindow
               }
    }
    
}
