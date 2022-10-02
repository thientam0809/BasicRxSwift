//
//  Property.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/24/22.
//

import UIKit
import RxSwift
import RxCocoa

@propertyWrapper
public struct Property<Value> {
    
    private var subject: BehaviorRelay<Value>
    private let lock = NSLock()
    
    public var wrappedValue: Value {
        get { return load() }
        set { store(newValue: newValue) }
    }
    
    public var projectedValue: BehaviorRelay<Value> {
        return self.subject
    }
    
    public init(wrappedValue: Value) {
        subject = BehaviorRelay(value: wrappedValue)
    }
    
    private func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return subject.value
    }
    
    private mutating func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        subject.accept(newValue)
    }
}

