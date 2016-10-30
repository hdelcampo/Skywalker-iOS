//
//  Vector3D.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 30/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

class Vector3D {
    
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

private extension Double {
    var toDegrees: Double { return self * 180 / .pi }
    var toRadians: Double { return self * .pi / 180 }
}
