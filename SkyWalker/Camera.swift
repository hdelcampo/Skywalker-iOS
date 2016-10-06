//
//  Camera.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 29/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import AVFoundation
import UIKit

class Camera {
    // MARK: Properties
    
    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice? = nil
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var horizontalFOV : Float { return (captureDevice?.activeFormat.videoFieldOfView)!}
    
    var verticalFOV : Float { return horizontalFOV * Float(view!.frame.width/view!.frame.height) }
    
    var view : UIView?
    
    static let instance = Camera()
    
    // MARK: Functions

    /**
     Finds rear camera -if any- and sets it as active device.
     */
    func setRearCamera() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices() as! [AVCaptureDevice]
        
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo) &&
                AVCaptureDevicePosition.back == device.position) {
                captureDevice = device
            }
        }
    }
    
    /**
     Begins images live preview
     */
    func beginSession() {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = (self.view?.layer.bounds)!
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view?.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
    }
    
}
