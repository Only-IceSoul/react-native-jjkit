//
//  GifDecoderProtocol.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import Foundation


public protocol GifDecoderProtocol {
    
    func decode(data:Data) -> Gif?
    
}
