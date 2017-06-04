//
//  OrientationSensor.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 27/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import CoreMotion
import GLKit

/**
    Device's orientation sensor.
 */
class OrientationSensor {
    
    //MARK : Properties
    
    /**
        Polling rate.
    */
    static let updateRate: Double = 1/60
    
    /**
        Orientation vector
    */
    private(set) var orientationVector: Vector3D = Vector3D(x: 1, y: 0, z: 0)
    
    /**
        Sensor manager.
    */
    let motionManager = CMMotionManager()
    
    /**
        Low pass filter alpha.
    */
    let alpha = 0.25
    
    /**
        The reference frame for the sensor.
    */
    private static let referenceFrame = CMAttitudeReferenceFrame.xMagneticNorthZVertical
    
    /**
        North offset.
    */
    private var northOffset: Double = 0
    
    //MARK: Functions
    
    /**
        Checks whether sensor is available or not.
        - Returns: true if available, false otherwise.
    */
    static func isAvailable () -> Bool {
        
        let availableReferences = CMMotionManager.availableAttitudeReferenceFrames()
        let motionManager = CMMotionManager()
        
        return motionManager.isDeviceMotionAvailable && availableReferences.contains(referenceFrame)
        
    }
    
    /**
        Starts registering events from the sensor
    */
    func registerEvents () {
        northOffset = User.instance.center!.mapNorthOffset
        motionManager.showsDeviceMovementDisplay = true
        motionManager.deviceMotionUpdateInterval = OrientationSensor.updateRate
        motionManager.startDeviceMotionUpdates(using: OrientationSensor.referenceFrame,
                                               to: OperationQueue(),
                                               withHandler: {
                                                (deviceMotion, error) -> Void in
                                                
                                                if (nil == error) {
                                                    self.updateData(from: deviceMotion!)
                                                }
                        
        })
    }
    
    /**
        Stops the sensor
    */
    func unregisterEvents () {
        motionManager.stopDeviceMotionUpdates()
    }
    
    /**
        Handler to update class members with correspondant data from the hardware.
        - Parameter from: The values.
    */
    private func updateData(from: CMDeviceMotion) {
        
        let rotationMatrix = from.attitude.rotationMatrix
        
        var calibratedVector = Vector2D(x: Double(-rotationMatrix.m31), y: Double(-rotationMatrix.m32))
        calibratedVector.rotateClockwise(degrees: northOffset)
        
        let filteredData = lowFilter(input: [calibratedVector.x, calibratedVector.y, -rotationMatrix.m33],
                  previousValues: [orientationVector.x, orientationVector.y, orientationVector.z])
        
        orientationVector = Vector3D(x: filteredData[0], y: filteredData[1], z: filteredData[2])

        orientationVector.normalize()
        
    }
    
    /**
        Low-pass filter to sensor data.
        - Parameters:
            - input: The values to filter.
            - previousValues: Old data.
        - Returns: The filtered values.
    */
    private func lowFilter(input: [Double], previousValues: [Double]) -> [Double] {
        
        var output: [Double] = [0, 0, 0]
        
        for i in 0..<3 {
            output[i] = previousValues[i] + alpha * (input[i] - previousValues[i]);
        }
        
        return output;
    }
    
}
