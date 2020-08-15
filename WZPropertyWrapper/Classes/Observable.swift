//
//  Observable.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2020/5/13.
//  Copyright © 2020 xiaobin liu. All rights reserved.
//

import Foundation

public protocol Observed: NSObjectProtocol {
  func broadcastValueWillChange<T>(newValue: T)
}

@propertyWrapper
public class Observable<Value: Equatable> {
  public var stored: Value
  weak var observed: Observed?
  
  public var projectedValue: Observable<Value> { self }
    
  public init(wrappedValue: Value) {
    self.stored = wrappedValue
  }
  
  public func register(_ observed: Observed) {
    self.observed = observed
  }
  
  public var wrappedValue: Value {
    get { return stored }
    set {
      if newValue != stored {
        observed?.broadcastValueWillChange(newValue: newValue)
      }
      stored = newValue
    }
  }
}
