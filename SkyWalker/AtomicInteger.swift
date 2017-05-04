//
//  AtomicInteger.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 4/5/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 A classic atomic integer using GCD.
 */
struct AtomicInteger {
    
    /**
        The integer value
    */
    private var value = 0
    
    /**
        The semaphore.
    */
    private let lock = DispatchSemaphore(value: 1)
    
    /**
     Changes the value.
     - Parameters:
        - newValue: The value.
     */
    mutating func set(_ newValue: Int) {
        lock.wait()
        defer {
            lock.signal()
        }
        value = newValue
    }
    
    /**
        Retrieves value.
        - Returns: The value.
    */
    func get() -> Int {
        lock.wait()
        defer {
            lock.signal()
        }
        return value
    }
    
    /**
        Increments the value.
     */
    mutating func increment() {
        lock.wait()
        defer {
            lock.signal()
        }
        value += 1
    }
    
    /**
      Decrements the  value.
     */
    mutating func decrement() {
        lock.wait()
        defer {
            lock.signal()
        }
        value -= 1
    }
    
}
