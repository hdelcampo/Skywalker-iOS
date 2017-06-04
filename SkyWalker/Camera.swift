//
//  Camera.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 29/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import AVFoundation
import UIKit

/**
    Camera facade.
*/
class Camera {
    // MARK: Properties
    
    /**
        Camera's capture session.
    */
    let captureSession = AVCaptureSession()
    
    /**
        Camera's device.
    */
    var captureDevice: AVCaptureDevice?
    
    /**
        Layer where camera will preview video.
    */
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    /**
        Horizontal field of view.
    */
    var horizontalFOV : Float { return (captureDevice?.activeFormat.videoFieldOfView)!}
    
    /**
        Vertical field of view.
    */
    var verticalFOV : Float { return horizontalFOV * Float(view!.frame.width/view!.frame.height) }
    
    /**
        The view that holds preview layer.
    */
    var view : UIView?
    
    /**
        Singleton instance.
    */
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
        Resumes a previous camera session.
    */
    func resume() {
        captureSession.startRunning()
    }
    
    /**
        Pauses the camera without destroying anything.
    */
    func pause() {
        captureSession.stopRunning()
    }
    
    /**
     Begins images live preview.
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
    
    /**
        Stops camera session.
    */
    func stopSession() {
        captureSession.removeInput(captureSession.inputs[0] as! AVCaptureInput)
        captureSession.stopRunning()
    }
    
    /**
        Rotates preview image.
        - Parameter orientation: Device's orientation.
    */
    func rotate(orientation: UIDeviceOrientation) {
        previewLayer?.frame = (view?.bounds)!
        switch orientation {
        case .portrait:
            previewLayer?.connection.videoOrientation = .portrait
        case .landscapeRight:
            previewLayer?.connection.videoOrientation = .landscapeLeft
        case .landscapeLeft:
            previewLayer?.connection.videoOrientation = .landscapeRight
        default:
            previewLayer?.connection.videoOrientation = .portrait
        }
    }
    
}
