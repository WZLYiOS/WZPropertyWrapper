//
//  Clamping.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation

/// [Swift Evolution Proposal example](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md#clamping-a-value-within-bounds)
/// [NSHisper article](https://nshipster.com/propertywrapper/)
@propertyWrapper
public struct Clamping<Value: Comparable> {
    
    var value: Value
    let range: ClosedRange<Value>
    
    public init(wrappedValue: Value, range: ClosedRange<Value>) {
        self.range = range
        self.value = range.clamp(wrappedValue)
    }
    
    public var wrappedValue: Value {
        get { value }
        set { value = range.clamp(newValue) }
    }
}

fileprivate extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return Swift.min(Swift.max(value, self.lowerBound), self.upperBound)
    }
}
