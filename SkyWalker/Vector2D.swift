//
//  Vector2D.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 15/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

struct Vector2D: Vector {
    
    /**
        Vector's components
    */
    var x: Double, y: Double
    
    typealias ItemType = Vector2D
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    mutating func normalize() {
        let length = module()
        x /= length
        y /= length
    }
    
    func angle(v: Vector2D) -> Double {
        let product = self * v
        let cos = product/(module()*v.module())
        return acos(cos).toDegrees
    }
    
    func module() -> Double {
        return sqrt((x*x) + (y*y))
    }
    
    /**
        Scalar product of two vectors.
        - Parameters:
            -v1: Left side of the multiplication.
            -v2: Right side of the multiplication.
        - Returns the scalar product of the two vectors.
    */
    static func * (v1: ItemType, v2: ItemType) -> Double {
        return (v1.x*v2.x) + (v1.y*v2.y)
    }
    
    /**
        Retrieves vector's inner angle with sign.
        - Parameter v: Other vector.
        - Returns: The inner angle in degrees, positive means clockwise, negative counter clockwise.
    */
    func angleWithSign(v: Vector2D) -> Double {
        let cos = self * v
        let det = x*v.y - v.x*y
        var angle = -atan2(det, cos).toDegrees
        
        if (angle < 0) {
            angle += 360
        }
        
        return angle
    }
    
    /**
        Rotates the vector clockwise conserving its module.
        - Parameter degrees: The degrees to be rotated.
    */
    mutating func rotateClockwise (degrees: Double) {
        let rad = -degrees.toRadians
        let cose = cos(rad)
        let sine = sin(rad)
    
        let newX = x*cose - y*sine
        let newY = x*sine + y*cose
    
        x = newX
        y = newY
    }
    
    
}
