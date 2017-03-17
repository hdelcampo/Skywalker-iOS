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
    
    static let AXIS_X = 2;
    static let AXIS_Y = 1;
    static let AXIS_Z = 3;
    static let AXIS_MINUS_X = AXIS_X | 0x80;
    static let AXIS_MINUS_Y = AXIS_Y | 0x80;
    static let AXIS_MINUS_Z = AXIS_Z | 0x80;
    
    /**
        Orientation vector
    */
    private var orientationVector: Vector3D = Vector3D(x: 1, y: 0, z: 0)
    
    let motionManager = CMMotionManager()
    let alpha = 0.25
    
    //MARK: Functions
    
    /**
        Starts registering events from the sensor
    */
    func registerEvents () {
        motionManager.deviceMotionUpdateInterval = OrientationSensor.updateRate
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                                               to: OperationQueue(),
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
        
        let r = from.attitude.rotationMatrix
        let rMatrix = GLKMatrix4Make(Float(r.m11), Float(r.m12), Float(r.m13), 0,
                                        Float(r.m21), Float(r.m22), Float(r.m23), 0,
                                        Float(r.m31), Float(r.m32), Float(r.m33), 0,
                                        0,     0,     0,     1)
        
        let rotated = GLKMatrix4RotateY(rMatrix, GLKMathDegreesToRadians(90))
        
        let orientationQuat = GLKQuaternionMakeWithMatrix4(rotated)
        let myVector = GLKVector3Make(Float(Center.instance.mapNorth.x),
                                      Float(Center.instance.mapNorth.y),
                                      0)
        
        let result = GLKQuaternionRotateVector3(orientationQuat, myVector)
        
        let filteredData = lowFilter(input: [result.x, result.y, result.z],
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
