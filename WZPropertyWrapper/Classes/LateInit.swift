//
//  LateInit.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation

@propertyWrapper

/// MARK - 延迟初始化
public struct LateInit<Value> {
    
    var storage: Value?
    
    public init() {
        storage = nil
    }
    
    public var wrappedValue: Value {
        get {
            guard let storage = storage else {
                fatalError("Trying to access LateInit.value before setting it.")
            }
            return storage
        }
        set {
            storage = newValue
        }
    }
}
