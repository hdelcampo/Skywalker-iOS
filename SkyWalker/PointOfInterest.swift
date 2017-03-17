//
//  PointOfInterest.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 4/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

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
    
    static func getDemoPoints() -> [PointOfInterest] {
        
        var points: [PointOfInterest] = []
        points.append(PointOfInterest(id: 0, name: "Wally"))
        points[0].x = 1
        points[0].y = 0

        /*points.append(PointOfInterest(id: 1, name: "Robin"))
        points[1].x = 50
        points[1].z = 45*/

        return points
        
    }
    
    static func ==(lhs: PointOfInterest, rhs: PointOfInterest) -> Bool {
        return lhs.id == rhs.id
    }
    
}
