//
//  AtomicWrite.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation


/// Some related reads & inspiration:
/// [swift-evolution proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md)
/// [obj.io](https://www.objc.io/blog/2019/01/15/atomic-variables-part-2/)
@available(iOS 2.0, OSX 10.0, tvOS 9.0, watchOS 2.0, *)
@propertyWrapper
public class AtomicWrite<Value> {

    // TODO: Faster version with os_unfair_lock?

    let queue = DispatchQueue(label: "com.wzly.AtomicWrite", attributes: .concurrent)
    var value: Value
    
    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    public var projectedValue: AtomicWrite<Value> { self }

    public var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync(flags: .barrier) { value = newValue }
        }
    }

    /// Atomically mutate the variable (read-modify-write).
    ///
    /// - parameter action: A closure executed with atomic in-out access to the wrapped property.
    public func mutate(_ mutation: (inout Value) throws -> Void) rethrows {
        return try queue.sync(flags: .barrier) {
            try mutation(&value)
        }
    }
}

private protocol Lock {
    func lock()
    func unlock()
}

extension Lock {
    /// Executes a closure returning a value while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    ///
    /// - Returns:           The value the closure generated.
    func around<T>(_ closure: () -> T) -> T {
        lock(); defer { unlock() }
        return closure()
    }

    /// Execute a closure while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    func around(_ closure: () -> Void) {
        lock(); defer { unlock() }
        closure()
    }
}

#if os(Linux)
/// A `pthread_mutex_t` wrapper.
final class MutexLock: Lock {
    private var mutex: UnsafeMutablePointer<pthread_mutex_t>

    init() {
        mutex = .allocate(capacity: 1)

        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, .init(PTHREAD_MUTEX_ERRORCHECK))

        let error = pthread_mutex_init(mutex, &attr)
        precondition(error == 0, "Failed to create pthread_mutex")
    }

    deinit {
        let error = pthread_mutex_destroy(mutex)
        precondition(error == 0, "Failed to destroy pthread_mutex")
    }

    fileprivate func lock() {
        let error = pthread_mutex_lock(mutex)
        precondition(error == 0, "Failed to lock pthread_mutex")
    }

    fileprivate func unlock() {
        let error = pthread_mutex_unlock(mutex)
        precondition(error == 0, "Failed to unlock pthread_mutex")
    }
}
#endif

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
/// An `os_unfair_lock` wrapper.
final class UnfairLock: Lock {
    private let unfairLock: os_unfair_lock_t

    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    fileprivate func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    fileprivate func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}
#endif

/// A thread-safe wrapper around a value.
@propertyWrapper
final class Protected<T> {
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    private let lock = UnfairLock()
    #elseif os(Linux)
    private let lock = MutexLock()
    #endif
    private var value: T

    init(_ value: T) {
        self.value = value
    }

    /// The contained value. Unsafe for anything more than direct read or write.
    var wrappedValue: T {
        get { lock.around { value } }
        set { lock.around { value = newValue } }
    }

    var projectedValue: Protected<T> { self }

    init(wrappedValue: T) {
        value = wrappedValue
    }

    /// Synchronously read or transform the contained value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The return value of the closure passed.
    func read<U>(_ closure: (T) -> U) -> U {
        lock.around { closure(self.value) }
    }

    /// Synchronously modify the protected value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The modified value.
    @discardableResult
    func write<U>(_ closure: (inout T) -> U) -> U {
        lock.around { closure(&self.value) }
    }

//    subscript<Property>(dynamicMember keyPath: WritableKeyPath<T, Property>) -> Property {
//        get { lock.around { value[keyPath: keyPath] } }
//        set { lock.around { value[keyPath: keyPath] = newValue } }
//    }
}
