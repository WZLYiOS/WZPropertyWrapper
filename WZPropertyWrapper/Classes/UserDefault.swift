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
public struct UserDefaultCodable<Value: Codable> : UserDefaultCodableProjectedValueProtocol{
    
    var key: String
    var wValue: Value?
    var userDefaults: UserDefaults
    public var projectedValue: UserDefaultCodableProjectedValue
    
    public init(_ key: String, userDefaults: UserDefaults = .standard) {
        self.projectedValue = UserDefaultCodableProjectedValue(key: key)
        self.key = key
        self.userDefaults = userDefaults
        self.wValue = getDefaults()
        self.projectedValue.delegate = self
    }
    
    public var wrappedValue: Value? {
        get {
            if  UserDefaults.standard.object(forKey: key) == nil {
                return nil
            }
            return wValue
        }
        set {
            wValue = newValue
            save()
        }
    }
    
    /// 获取数据
    private func getDefaults() -> Value? {
        guard let jsonString = UserDefaults.standard.object(forKey: key) as? String,
            let jsonData = jsonString.data(using: .utf8),
              let result = try? JSONDecoder().decode(Value.self, from: jsonData) else {
                return nil
        }
        return result
    }
    
    /// 保存
    func save() {
        
        let newValue = wValue
        if newValue == nil {
            return UserDefaults.standard.removeObject(forKey: key)
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(newValue),
            let stringJson = String(data: data, encoding: .utf8) else {
                return
        }
        UserDefaults.standard.set(stringJson, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /// 移除
     func remove(){
        UserDefaults.standard.removeObject(forKey: key)
    }
}

protocol UserDefaultCodableProjectedValueProtocol {
    func save()
    func remove()
}

// MARK - 状态值
public class UserDefaultCodableProjectedValue: NSObject {
        
    public var key: String
    var delegate: UserDefaultCodableProjectedValueProtocol?
    
    init(key: String) {
        self.key = key
    }
    
    public func save(){
        delegate?.save()
    }
    
    public func remove(){
        delegate?.remove()
    }
}



