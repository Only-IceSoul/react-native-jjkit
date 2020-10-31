//
//  Request.swift
//  JJGuiso
//
//  Created by Juan J LF on 10/29/20.
//

import Foundation


public protocol Request {
    func begin()
    func clear()
    func isComplete() -> Bool
    func isRunning() -> Bool
    func isCleared() -> Bool
}
