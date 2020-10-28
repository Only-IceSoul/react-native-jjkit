//
//  File.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 10/27/20.
//

import Foundation


struct File {
    
    init() {
        
    }
    
    init(url:URL,modificationDate:Date,allocateSize:Int) {
        self.url = url
        self.modificationDate = modificationDate
        self.allocateSize = allocateSize
    }
    
    var url : URL?
    var modificationDate: Date?
    var allocateSize: Int?
    
    
}
