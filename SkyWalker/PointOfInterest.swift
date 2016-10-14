//
//  PointOfInterest.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 4/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import Foundation
import QuartzCore

class PointOfInterest {
    
    //MARK: Properties
    
    private (set) var x = 0,
        y = 0,
        z = 0
    
    let id : String
    
    let distance: Double = 50
    
    let velocity: Double = 0.2
    
    private (set) var direction: Double = 0
    
    init(name: String, x: Int, y: Int, z: Int){
        id = name
        self.x = x
        self.y = y
        self.z = z
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: { _ -> Void in
                let LENGTH = 40.0
                let INITIAL_POS = LENGTH/2
                let value: Double = (CACurrentMediaTime()*25).remainder(dividingBy: LENGTH) + 20
                if (value >= LENGTH/2) {
                    self.direction = LENGTH - value - INITIAL_POS
                }
                else {
                    self.direction = value - INITIAL_POS
                }
            })
        }
    }
    
}
