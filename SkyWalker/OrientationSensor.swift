//
//  OrientationSensor.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 27/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import CoreMotion
import GLKit

class OrientationSensor {
    
    //MARK : Properties
    
    private(set) var azimuth : Double = 0
    private(set) var pitch : Double = 0
    private(set) var roll : Double = 0
    
    let motionManager = CMMotionManager()
    static let updateRate: Double = 1/60
    let alpha = 0.25
    
    //MARK: Functions
    
    /**
        Starts registering events from the sensor
    */
    func registerEvents () {
        motionManager.deviceMotionUpdateInterval = OrientationSensor.updateRate
        motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical,
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
    private func updateData(from: CMDeviceMotion) {
        //We cant set a custom reference frame, but we can transform data using our own reference frame
        //Notice gimbal lock will also occur when looking 90º up or down, if that happens, we must move to quaternions
        let attitude = from.attitude
        
        let q = rotate(quaternion: attitude.quaternion, axes: [0,0,1], radians: Float(M_PI/2))
        
        pitch  = atan2(Double(2.0*q.y*q.w - 2.0*q.x*q.z), Double(1 - 2.0*q.y*q.y - 2.0*q.z*q.z)).toDegrees + 90
        azimuth = atan2(Double(2.0*q.x*q.w - 2.0*q.y*q.z), Double(1 - 2.0*q.x*q.x - 2.0*q.z*q.z)).toDegrees
        roll =  asin(Double(2.0*q.x*q.y + 2.0*q.z*q.w)).toDegrees
    }
    
    private func rotate(quaternion: CMQuaternion, axes: [Float], radians: Float) -> GLKQuaternion {
        
        var originalQuaternion = GLKQuaternionMake(Float(quaternion.x), Float(quaternion.y), Float(quaternion.z), Float(quaternion.w))
        var rotationQuaternion = GLKQuaternionMakeWithAngleAndAxis(radians, axes[0], axes[1], axes[2])
        
        originalQuaternion = GLKQuaternionNormalize(originalQuaternion)
        rotationQuaternion = GLKQuaternionNormalize(rotationQuaternion)
        
        let rotatedQuaternion = GLKQuaternionMultiply(originalQuaternion, rotationQuaternion)
        
        return rotatedQuaternion
        
    }
    
    /**
        Low-pass filter to sensor data
    */
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
