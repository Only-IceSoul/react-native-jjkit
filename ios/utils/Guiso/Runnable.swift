//
//  Runnable.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import Foundation

public protocol  Runnable {
    
    func setTask(_ t:DispatchWorkItem)
    func run()
    
}
