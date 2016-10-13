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
    let alpha = 0.25
    
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
        //Due to lack of pitch distinguish between up and down, we need gravity data to know which one we are facing.
        //Also, notice we are taking Android reference so code is all compatible
        let gravity = from.gravity
        let attitude = from.attitude
        
        var rotateVector = [azimuth, pitch, roll]
        rotateVector = lowFilter(input: [attitude.yaw, attitude.pitch, attitude.roll],
                                 previousValues: rotateVector)
        roll = attitude.roll.toDegrees
        azimuth = -attitude.yaw.toDegrees
        
        pitch = attitude.pitch.toDegrees - 90
        pitch = -copysign(pitch, gravity.z)
    }
    
    private func lowFilter(input: [Double], previousValues: [Double]?) -> [Double] {
        if (nil == previousValues){
            return input;
        }
        
        var output: [Double] = [0, 0, 0]
        
        for i in 0..<3 {
            output[i] = previousValues![i] + alpha * (input[i] - previousValues![i]);
        }
        
        return output;
    }
    
}

private extension Double {
    var toDegrees: Double { return self * 180 / .pi }
}
