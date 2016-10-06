//
//  PointOfInterest.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 4/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

class PointOfInterest {
    
    //MARK: Properties
    
    var x = 0,
        y = 0,
        z = 0
    
    let id : String
    
    init(name: String, x: Int, y: Int, z: Int){
        id = name
        self.x = x
        self.y = y
        self.z = z
    }
}
