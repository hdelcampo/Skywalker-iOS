//
//  Vector.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 15/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 Interface for geometric vectors.
 */
protocol Vector {
    
    associatedtype ItemType
    
    /**
     Normalizes the vector.
     */
    mutating func normalize()
    
    /**
     Finds the inner angle between vectors.
     */
    func angle(v: ItemType) -> Double
    
    /**
     Finds the vector's length.
     - Returns: The vector's length.
     */
    func module() -> Double
    
    //static func *(left: Self, right: ItemType) -> Double
    
}
