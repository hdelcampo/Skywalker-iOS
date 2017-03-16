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
struct Vector3D: Vector {
    
    typealias ItemType = Vector3D
    
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
    
    func module() -> Double {
        return sqrt((x*x) + (y*y) + (z*z))
    }
    
    mutating func normalize() {
        let length = module()
        x /= length
        y /= length
        z /= length
    }
    
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
    static func * (v1: ItemType, v2: ItemType) -> Double {
        return (v1.x*v2.x) + (v1.y*v2.y) + (v1.z*v2.z)
    }
    
    /**
        Retrieves angle in degrees, values from [0, 360).
    */
    static func getAngle(x: Double, y: Double) -> Double {
        
        var angle = atan2(y, x).toDegrees
        
        if (angle < 0) {
            // Sum complete circle
            angle += 180*2;
        }
        
        return angle
    }
    
}
