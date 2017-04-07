//
//  QRConnectionViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 7/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import AVFoundation

/**
    QR Connection view controller.
 */
class QRConnectionViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startCameraPreviewWithQRDetection()
    }
    
    /**
        Starts the camera preview with QR detection enabled.
    */
    private func startCameraPreviewWithQRDetection() {
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let input: AnyObject! = try? AVCaptureDeviceInput.init(device: captureDevice)
        let captureSession = AVCaptureSession()
        captureSession.addInput(input as! AVCaptureInput)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue(label: "QR Detection queue"))
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = cameraView.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if (nil == metadataObjects || metadataObjects.count == 0) {
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            print(metadataObj.stringValue)
            if (isXtremeLocQR(qr: metadataObj.stringValue)) {
                treat(qr: metadataObj.stringValue)
            } else {
                show(error: .INVALID_QR)
            }
        }
        
    }
    
    /**
        Detects whether a QR is valid as XtremeLoc scheme or not.
        - Returns: True if QR is a valid XtremeLoc one, false otherwise.
    */
    private func isXtremeLocQR(qr: String) -> Bool {
        
        let qrData = qr.data(using: .utf8)!
        
        if let json = try! JSONSerialization.jsonObject(with: qrData, options: []) as? Dictionary<String, Any> {
            return json["scheme"] != nil
        } else {
            return false
        }

    }
    
    /**
        Handles a QR code.
    */
    private func treat(qr: String) {
        
    }
    
    func show(error: ServerFacade.ErrorType) {
        print(String(describing: error))
    }

}
