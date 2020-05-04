//
//  extension_ColorMap.swift
//  Guiso
//
//  Created by Juan J LF on 5/3/20.
//

import UIKit

struct Color : Hashable {
    let red: UInt8
    let green: UInt8
    let blue: UInt8

     public var hashValue: Int {
         var hasher = Hasher()
         self.hash(into: &hasher)
         return hasher.finalize()
     }
      
    public func hash(into hasher: inout Hasher) {
           hasher.combine(Int(red))
            hasher.combine(Int(green))
            hasher.combine(Int(blue))
        
       }
       
  public static func == (lhs: Color, rhs: Color) -> Bool {
      return [lhs.red, lhs.green, lhs.blue] == [rhs.red, rhs.green, rhs.blue]
  }
}


struct ColorMap {
    var colors = Set<Color>()

    var exported: Data {
        let data = Array(colors)
            .map { [$0.red, $0.green, $0.blue] }
            .joined()

        return Data(data)
    }
}

extension CGImage{

    func getColorMap() -> ColorMap {

        var colorMap = ColorMap()

        let pixelData = self.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        var byteIndex = 0

        for _ in 0 ..< Int(height){
            for _ in 0 ..< Int(width){

                let color = Color(red: data[byteIndex], green: data[byteIndex + 1], blue: data[byteIndex + 2])
                colorMap.colors.insert(color)
                byteIndex += 4
            }
        }

        return colorMap
    }
}
