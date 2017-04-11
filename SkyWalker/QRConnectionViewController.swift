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
class QRConnectionViewController: NewConnectionViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLayoutSubviews() {
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
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = cameraView.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraView.layer.addSublayer(previewLayer!)
        
        DispatchQueue.global(qos: .default).async {_ in

            captureSession.startRunning()
            
        }
        
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
    
    override func show(error: ServerFacade.ErrorType) {
        print(String(describing: error))
    }

}
