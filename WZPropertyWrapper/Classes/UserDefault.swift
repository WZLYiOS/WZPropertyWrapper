//
//  UserDefault.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation

/// [Apple documentation on UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)
@available(iOS 2.0, OSX 10.0, tvOS 9.0, watchOS 2.0, *)
@propertyWrapper
public struct UserDefault<Value: PropertyListValue> {
    let key: String
    let defaultValue: Value
    var userDefaults: UserDefaults
    
    public init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    public var wrappedValue: Value {
        get {
            return userDefaults.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}

public protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension NSData: PropertyListValue {}

extension String: PropertyListValue {}
extension NSString: PropertyListValue {}

extension Date: PropertyListValue {}
extension NSDate: PropertyListValue {}

extension NSNumber: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Int8: PropertyListValue {}
extension Int16: PropertyListValue {}
extension Int32: PropertyListValue {}
extension Int64: PropertyListValue {}
extension UInt: PropertyListValue {}
extension UInt8: PropertyListValue {}
extension UInt16: PropertyListValue {}
extension UInt32: PropertyListValue {}
extension UInt64: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}
#if os(macOS)
extension Float80: PropertyListValue {}
#endif

extension Array: PropertyListValue where Element: PropertyListValue {}

extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}
