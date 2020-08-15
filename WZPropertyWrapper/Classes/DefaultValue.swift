//
//  DefaultValue.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DefaultValue<Value> {
    
    // MARK: - Members
    private var value: Value?

    private let defaultValue: Value

    // MARK: - Property wrapper interface
    public var wrappedValue: Value! {
        get {
            if let unboxed = value {
                return unboxed
            }

            return defaultValue
        }
        set {
            value = newValue
        }
    }

    // MARK: - Init
    public init(wrappedValue: Value? = nil, default: Value) {
        defaultValue = `default`
        value = wrappedValue
    }
    
    // MARK: - Public API
    
    /// Resets the wrapper to its default value.  This is equivalent to setting nil.
    public mutating func reset() {
        value = nil
    }
}
