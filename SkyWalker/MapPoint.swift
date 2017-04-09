//
//  MapPoint.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 9/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 A Map point, with coordinates, number of floor and ID.
 */
class MapPoint: Equatable {
    
    var x: Double, y: Double
    
    var z: Int
    
    let id: Int
    
    var isUndefined: Bool {
        get {
            return (x == -1 && y == -1)
        }
    }
    
    /**
        Creates a new map point
        - Parameters:
            - id: Id of the point.
            - x: coordinate.
            - y: coordinate.
            - z: number of floor.
    */
    init(id: Int, x: Double, y: Double, z: Int) {
        self.id = id
        self.x = x
        self.y = y
        self.z = z
    }
    
    static func ==(lhs: MapPoint, rhs: MapPoint) -> Bool {
        return lhs.id == rhs.id
    }
    
}
