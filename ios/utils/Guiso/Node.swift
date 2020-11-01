//
//  Node.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 10/31/20.
//

import UIKit


public class Node<U,T> {
    var key: U
    var value: T
    var next: Node?
    weak var previous: Node?

    public init(key:U,value: T) {
        self.value = value
        self.key = key
    }
}
