//
//  Vector3D.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 30/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 Geometric 3D Vector.
*/
struct Vector3D {
        
    /**
     Vector's components
     */
    private(set) var x: Double, y: Double, z: Double
    
    /**
        Constructs a new 3D Vector.
        - Parameters:
            - x: X component.
            - y: Y component.
            - z: Z component.
    */
    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /**
     Retrieves the vector's length.
     - Returns: The vector's length.
     */
    func module() -> Double {
        return sqrt((x*x) + (y*y) + (z*z))
    }
    
    /**
     Normalizes the vector.
     */
    mutating func normalize() {
        let length = module()
        x /= length
        y /= length
        z /= length
    }
    
    /**
     Finds the inner angle between vectors.
     - Parameter v: The other vector.
     - Returns: The inner angle in degrees.
     */
    func angle(v: Vector3D) -> Double {
        let product = self * v
        let cos = product/(module()*v.module())
        return acos(cos).toDegrees
    }
    
    /**
     Scalar product of two vectors.
     - Parameters:
        -v1: Left side of the multiplication.
        -v2: Right side of the multiplication.
     - Returns the scalar product of the two vectors.
     */
    static func * (v1: Vector3D, v2: Vector3D) -> Double {
        return (v1.x*v2.x) + (v1.y*v2.y) + (v1.z*v2.z)
    }
    
}
