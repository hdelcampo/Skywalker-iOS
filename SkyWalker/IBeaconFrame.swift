//
//  IBeaconFrame.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 18/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation
import CoreLocation

/**
 iBeacon frame.
 */
struct IBeaconFrame {
    
    // MARK: Properties
    
    /**
        UUID of the frame.
    */
    let uuid: UUID
    
    /**
        Major of the frame.
    */
    let major: CLBeaconMajorValue
    
    /**
        Minor of the frame.
    */
    let minor: CLBeaconMinorValue
    
    
    // MARK: Init
    
    /**
        Creates a new inmutable iBeacon frame.
        - Parameters:
            - uuid: UUID.
            - major: Major.
            - minor: Minor.
    */
    init(uuid: UUID, major: Int, minor: Int) {
        self.uuid = uuid
        self.major = CLBeaconMajorValue(major)
        self.minor = CLBeaconMinorValue(minor)
    }
    
}
