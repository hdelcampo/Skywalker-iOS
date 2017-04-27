//
//  Center.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 16/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

class Center {
    
    let id: Int
    
    private(set) var mapNorth: Vector2D
    static var centers = [Center]()
    var receivers: [MapPoint]?
    var scale = 200.0
    
    init(id: Int) {
        self.id = id
        mapNorth = Vector2D(x: 1, y: 0)
    }
    
}
