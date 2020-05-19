//
//  GuisoHeader.swift
//  Jjkit
//
//  Created by Juan J LF on 5/18/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

public class GuisoHeader {
    
    private var mFields = [String:String]()
        
    public func addHeader(key:String,value:String) -> GuisoHeader{
        mFields[key] = value
        return self
    }
    
    public func getFields() -> [String:String]{
        return mFields
    }
   
}
