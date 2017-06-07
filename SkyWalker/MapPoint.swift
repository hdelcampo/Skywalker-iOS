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
class MapPoint: Hashable {
    
    /**
        Map coordinates.
    */
    var x: Double,
        y: Double
    
    /**
        Floor number.
    */
    var z: Int
    
    /**
        Point's id.
    */
    let id: Int
    
    /**
        Indicates if position is undefined.
    */
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
    
    /**
     Retrieves the updated position from persistence system.
        - Parameters:
            - successDelegate: Success callback.
            - errorDelegate: Error callback.
     */
    func updatePosition(successDelegate: (() -> Void)?,
                        errorDelegate: ((PersistenceErrors) -> Void)?) {
        
        let onSuccess: (MapPoint) -> Void = { position in
                self.x = position.y
                self.y = position.x
                self.z = position.z
        }
        
        let onError: (ServerFacade.ErrorType) -> Void = {error in
            
            let realError: PersistenceErrors
            
            switch(error) {
            case .NO_CONNECTION, .TIME_OUT:
                realError = .INTERNET_ERROR
            default:
                realError = .SERVER_ERROR
            }
            
            errorDelegate?(realError)
            
        }
        
        try! ServerFacade.instance.getLastPosition(tag: self.id, onSuccess: onSuccess, onError: onError)
        
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func ==(lhs: MapPoint, rhs: MapPoint) -> Bool {
        return lhs.id == rhs.id
    }
    
}
