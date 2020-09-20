//
//  GuisoHeader.swift
//  Guiso
//
//  Created by Juan J LF on 5/18/20.
//

import Foundation


public class GuisoHeader {
    
    private var mFields = [String:String]()
    
    init(_ headers:[String:String]) {
       mFields = headers
    }
    
    init() {}
        
    public func addHeader(key:String,value:String) -> GuisoHeader{
        mFields[key] = value
        return self
    }
    
    public func getFields() -> [String:String]{
        return mFields
    }
   
}

