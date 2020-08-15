//
//  EnvironmentVariable.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation

/// Some related reads & inspiration:
/// [swift-evolution proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md)
/// [Environment variables in Mac OSX](https://stackoverflow.com/a/4567308)
@propertyWrapper
public struct EnvironmentVariable {
    var name: String
    
    public var wrappedValue: String? {
        get {
            guard let pointer = getenv(name) else { return nil }
            return String(cString: pointer)
        }
        set {
            guard let value = newValue else {
                unsetenv(name)
                return
            }
            setenv(name, value, 1)
        }
    }
}
