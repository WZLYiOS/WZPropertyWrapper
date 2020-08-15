//
//  Expirable.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation

/// [Courtesy of @v_pradeilles](https://twitter.com/v_pradeilles)
@propertyWrapper
public struct Expirable<Value> {
    
    let duration: TimeInterval
    
    /// Stores a value toguether with its expiration date.
    var storage: (value: Value, expirationDate: Date)?
    
    /// Instantiate the wrapper with no initial value.
    public init(duration: TimeInterval) {
        self.duration = duration
        storage = nil
    }
    
    /// Instantiate the wrapper with an initial value and its expiration date, toguether with a duration.
    ///
    /// This method is meant to be used when a value is restored from some form of persistent storage and the expiration
    /// is well known and doesn't depend on the current date. It is perfectly fine to pass an expiration date in the past; the
    /// wrapper will simply treat the initial value as expired inmediatly.
    ///
    /// The duration will be ignored for this initial value but will be used as soon as a new value is set.
    public init(wrappedValue: Value, expirationDate: Date, duration: TimeInterval) {
        self.duration = duration
        storage = (wrappedValue, expirationDate)
    }
    
    public var wrappedValue: Value? {
        get {
            isValid ? storage?.value : nil
        }
        set {
            storage = newValue.map { newValue in
                let expirationDate = Date().addingTimeInterval(duration)
                return (newValue, expirationDate)
            }
        }
    }
    
    /// A Boolean value that indicates whether the expirable value is still valid or has expired.
    public var isValid: Bool {
        guard let storage = storage else { return false }
        return storage.expirationDate >= Date()
    }
    
    /// Set a new value toguether with its expiration date.
    ///
    /// By calling this method the duration set while constructing the property wrapper will be ignored for this concrete new value.
    /// Setting a new value without using this method will revert back to use the duration to compute the expiration date.
    public mutating func set(_ newValue: Value, expirationDate: Date) {
        storage = (newValue, expirationDate)
    }
}
