//
//  LoaderProtocol.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit


public protocol LoaderProtocol {
    
    func loadData(model:Any?,width:CGFloat,height:CGFloat,options:GuisoOptions,callback:@escaping (Any?,Guiso.LoadType,String,Guiso.DataSource) -> Void)

 
    func cancel()
    
    func pause()
    
    func resume()
    
    
}
