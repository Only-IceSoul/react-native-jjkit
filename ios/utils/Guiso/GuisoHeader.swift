//
//  GuisoHeader.swift
//  Guiso
//
//  Created by Juan J LF on 5/18/20.
//

import Foundation


public class GuisoHeader : Equatable {
    
    
    public static func == (lhs: GuisoHeader, rhs: GuisoHeader) -> Bool {
        return lhs.mFields == rhs.mFields
    }
    
    
    private var mFields = [String:String]()
    
    public init(_ headers:[String:String]){
        mFields = headers
    }
    
    public init(){}
    
    public func addHeader(key:String,value:String) -> GuisoHeader{
        mFields[key] = value
        return self
    }
    
    public func getFields() -> [String:String]{
        return mFields
    }
   
}

