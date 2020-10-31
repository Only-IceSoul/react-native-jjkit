//
//  File.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 10/27/20.
//

import Foundation


public struct File {
    
    public init() {
        
    }
    
    public init(url:URL,modificationDate:Date,allocateSize:Int) {
        self.url = url
        self.modificationDate = modificationDate
        self.allocateSize = allocateSize
    }
    
    public var url : URL?
    public var modificationDate: Date?
    public var allocateSize: Int?
    
    
}
