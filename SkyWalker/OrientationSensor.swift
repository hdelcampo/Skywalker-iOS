//
//  OrientationSensor.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 27/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import CoreMotion

class OrientationSensor {
    
    //MARK : Properties
    
    private(set) var azimuth : Double = 0
    private(set) var pitch : Double = 0
    private(set) var roll : Double = 0
    
    let motionManager = CMMotionManager()
    let updateRate: Double = 1/60
    
    //MARK: Functions
    
    /**
        Starts registering events from the sensor
    */
    func registerEvents () {
        motionManager.deviceMotionUpdateInterval = updateRate
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                                               to: OperationQueue.current!,
                                               withHandler: {
                                                (deviceMotion, error) -> Void in
                                                
                                                if (nil == error) {
                                                    self.updateData(from: deviceMotion!)
                                                } else {
                                                    //TODO: error
                                                }
        })
    }
    
    /**
        Handler to update class members with correspondant data from the hardware
    */
    private func updateData(from: CMDeviceMotion){
        let attitude = from.attitude
        roll = attitude.roll.toDegrees
        pitch = attitude.pitch.toDegrees - 90
        azimuth = attitude.yaw.toDegrees
        
        if abs(roll) < 100 {
            pitch = -pitch
        }
    }
    
}

private extension Double {
    var toDegrees: Double { return self * 180 / .pi }
}
