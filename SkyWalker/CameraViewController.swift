//
//  CameraViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 24/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: Properties
    
    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice? = nil
    
    var previewLayer : AVCaptureVideoPreviewLayer?

    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setRearCamera()
        
        if (nil != captureDevice) {
            beginSession()
        }
    }
    
    // MARK: Functions
    
    /**
        Finds rear camera -if any- and sets it as active device.
    */
    private func setRearCamera() {
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
    private func beginSession() {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }

        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = self.view.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
    }

}
