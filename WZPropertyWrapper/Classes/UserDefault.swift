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


// MARK - 存储Codable类型
@available(iOS 2.0, OSX 10.0, tvOS 9.0, watchOS 2.0, *)
@propertyWrapper
public struct UserDefaultCodable<Value: Codable&UserDefaultCodableStorage> {
    
    let key: String
    var defaultValue: Value
    var wValue: Value?
    var userDefaults: UserDefaults
    
    public init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
        self.wValue = getDefaults()
        self.wValue?.storageKey = key
        self.defaultValue.storageKey = key
    }
    
    public var wrappedValue: Value {
        get {
            if UserDefaults.standard.object(forKey: key) == nil {
                return defaultValue
            }
            return wValue ?? defaultValue
        }
        set {
            wValue = newValue
            newValue.save()
        }
    }
    
    func getDefaults() -> Value {
        guard let jsonString = UserDefaults.standard.object(forKey: key) as? String,
            let jsonData = jsonString.data(using: .utf8),
              let result = try? JSONDecoder().decode(Value.self, from: jsonData) else {
                return defaultValue
        }
        return result
    }
}


// MARK - 数据缓存
public protocol UserDefaultCodableStorage {
        
    /// 保存对象到UserDefaults
    ///
    /// - Parameter defaultName: key(最好key最好以工程的BundleId+key，以避免冲突)
    /// - Returns: 保存是否成功
    @discardableResult
    func save() -> Bool
    
    /// 移出
    ///
    /// - Parameter defaultName: key
    /// - Returns: 是否成功
    @discardableResult
    func remove() -> Bool
    
    /// 缓存key
    var storageKey: String  { get set }
}

private struct AssociatedKey {
    static var locationKey: String = "com.wzly.location.location"
}

// MARK: - Codable
extension UserDefaultCodableStorage where Self: Codable {
    
   public var storageKey: String {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.locationKey) as? String ?? ""
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.locationKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    @discardableResult
    public func save() -> Bool {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self),
            let stringJson = String(data: data, encoding: .utf8) else {
                return false
        }
        UserDefaults.standard.set(stringJson, forKey: storageKey)
        return UserDefaults.standard.synchronize()
    }
    
    @discardableResult
    public func remove() -> Bool {
        UserDefaults.standard.removeObject(forKey: storageKey)
        return UserDefaults.standard.synchronize()
    }
}
