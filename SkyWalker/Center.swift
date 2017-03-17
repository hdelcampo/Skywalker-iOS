//
//  Center.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 16/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

class Center {
    
    private(set) var mapNorth: Vector2D
    static let instance = Center()
    
    init() {
        mapNorth = Vector2D(x: 1, y: 0)
    }
    
}
