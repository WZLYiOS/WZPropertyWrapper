//
//  UndoRedo.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation

/// [Original idea by @JeffHurray](https://twitter.com/JeffHurray/status/1137816198689673216)
/// Ideas for API on [Foundation UndoManager](https://developer.apple.com/documentation/foundation/undomanager)
/// [Chris Eidhof blog post](http://chris.eidhof.nl/post/undo-history-in-swift/)
@propertyWrapper
public struct UndoRedo<Value> {
    
    var index: Int
    var values: [Value]
    
    public init(wrappedValue: Value) {
        self.values = [wrappedValue]
        self.index = 0
    }
    
    public var wrappedValue: Value {
        get {
            values[index]
        }
        set {
            // Inserting a new value drops any existing redo stack.
            if canRedo {
                values = Array(values.prefix(through: index))
            }
            values.append(newValue)
            index += 1
        }
    }
    
    // MARK: Wrapper public API
    
    /// A Boolean value that indicates whether the receiver has any actions to undo.
    public var canUndo: Bool {
        return index > 0
    }
    
    /// A Boolean value that indicates whether the receiver has any actions to redo.
    public var canRedo: Bool {
        return index < (values.endIndex - 1)
    }
    
    /// If there are previous values it replaces the current value with the previous one and returns true, otherwise returns false.
    @discardableResult
    public mutating func undo() -> Bool {
        guard canUndo else { return false }
        index -= 1
        return true
    }
    
    /// It reverts the last `undo()` call and returns true if any, otherwise returns false.
    /// Whenever a new value is assigned to the wrapped property any existing "redo stack" is dropped.
    @discardableResult
    public mutating func redo() -> Bool {
        guard canRedo else { return false }
        index += 1
        return true
    }
    
    /// Cleans both the undo and redo history leaving only the current value.
    public mutating func cleanHistory() {
        values = [values[index]]
        index = 0
    }
    
    // TODO: A way to implement this just storing diffs?
    // It might not be particularly usefull since it will require Value to conform to some sort of
    // diffable protocol.
    // Maybe I could implement one version just for table/collection view data sources.
    
    // TODO: Add support for limited-size history; e.g. 50
    
    // TODO: Potential alternative version supporting foundation undomanager https://developer.apple.com/documentation/foundation/undomanager
}
