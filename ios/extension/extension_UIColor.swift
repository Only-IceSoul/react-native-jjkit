//
//  extension_UIColor.swift
//  AnimationPractica
//
//  Created by Juan J LF on 3/22/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit

extension UIColor{
    
    static func parseColor(_ hex: String) -> UIColor? {
          var chars = Array(hex.hasPrefix("#") ? hex.dropFirst() : hex[...])
          let red, green, blue, alpha: CGFloat
          switch chars.count {
          case 3:
              chars = chars.flatMap { [$0, $0] }
              fallthrough
          case 6:
              chars = ["F","F"] + chars
              fallthrough
          case 8:
              alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
              red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
              green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
              blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
          default:
              return nil
          }
         return self.init(red: red, green: green, blue:  blue, alpha: alpha)
      }
}
