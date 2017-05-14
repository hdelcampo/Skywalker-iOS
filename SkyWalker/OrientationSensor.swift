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
    
    static let updateRate: Double = 1/60
    
    var x: Double {
        get {
            return orientationVector.x
        }
    }
    
    var y: Double {
        get {
            return orientationVector.y
        }
    }
    
    var z: Double {
        get {
            return orientationVector.z
        }
    }
    
    /**
        Orientation vector
    */
    private(set) var orientationVector: Vector3D = Vector3D(x: 1, y: 0, z: 0)
    
    let motionManager = CMMotionManager()
    let alpha = 0.25
    let deviceReference = Vector3D(x: 1, y: 0, z: 0)
    
    /**
        The reference frame for the sensor.
    */
    private static let referenceFrame = CMAttitudeReferenceFrame.xMagneticNorthZVertical
    
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
        Handler to update class members with correspondant data from the hardware
    */
    private func updateData(from: CMDeviceMotion) {
        
        let r = from.attitude.rotationMatrix
        let rMatrix = GLKMatrix4Make(Float(r.m11), Float(r.m12), Float(r.m13), 0,
                                        Float(r.m21), Float(r.m22), Float(r.m23), 0,
                                        Float(r.m31), Float(r.m32), Float(r.m33), 0,
                                        0,     0,     0,     1)
        
        let rotated = GLKMatrix4RotateY(rMatrix, GLKMathDegreesToRadians(90))
        
        let orientationQuat = GLKQuaternionMakeWithMatrix4(rotated)
        let myVector = GLKVector3Make(Float(deviceReference.x),
                                      Float(deviceReference.y),
                                      0)
        
        let result = GLKQuaternionRotateVector3(orientationQuat, myVector)
        
        var calibratedVector = Vector2D(x: Double(result.x), y: Double(result.y))
        calibratedVector.rotateClockwise(degrees: 30)
        
        let filteredData = lowFilter(input: [Float(calibratedVector.x), Float(calibratedVector.y), result.z],
                  previousValues: [orientationVector.x, orientationVector.y, orientationVector.z])
        
        orientationVector = Vector3D(x: filteredData[0], y: filteredData[1], z: filteredData[2])
        orientationVector.normalize()
        
    }
    
    /**
        Low-pass filter to sensor data
    */
    private func lowFilter(input: [Float], previousValues: [Double]) -> [Double] {
        
        var output: [Double] = [0, 0, 0]
        
        for i in 0..<3 {
            output[i] = previousValues[i] + alpha * (Double(input[i]) - previousValues[i]);
        }
        
        return output;
    }
    
}
