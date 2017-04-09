//
//  PointOfInterest.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 4/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

/**
 A point to be shown on screen
 */
class PointOfInterest: Equatable {
    
    //MARK: Properties
    
    var x: Double = 0,
        y: Double = 0,
        z: Double = 0
    
    let id : Int
    let name: String
    static var observer: OverlayViewController?
    static var points: [PointOfInterest]! {
        didSet {
            if (nil != observer){
                observer!.points = self.points
            }
        }
    }
    
    let distance: Double = 50
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    /**
        Retrieves a list of points prepared for demostration purposes.
        - Returns: A list of demostration points.
    */
    static func getDemoPoints() -> [PointOfInterest] {
        
        var points: [PointOfInterest] = []
        points.append(PointOfInterest(id: 0, name: "Dani"))
        points[0].y = 0.5
        points[0].x = 0

        points.append(PointOfInterest(id: 1, name: "Diego"))
        points[1].y = 0
        points[1].x = 0.5
        
        points.append(PointOfInterest(id: 2, name: "Ana"))
        points[2].x = 0.5
        points[2].y = 1
        
        points.append(PointOfInterest(id: 3, name: "Sergio"))
        points[3].x = 1
        points[3].y = 0.5

        return points
        
    }
    
    static func ==(lhs: PointOfInterest, rhs: PointOfInterest) -> Bool {
        return lhs.id == rhs.id
    }
    
}
