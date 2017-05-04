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
    
    /**
     Connection status
     */
    var connecting = false

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
        
        if let json = try? JSONSerialization.jsonObject(with: qrData, options: []) as? Dictionary<String, Any> {
            return json!["scheme"] != nil
        } else {
            return false
        }

    }
    
    
    /**
        Handles a QR code.
    */
    private func treat(qr: String) {
        
        if connecting {
            return
        }
        
        connecting = true
        
        let data = qr.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, String>
        
        let url = json["url"]!
        let username: String? = json["username"]
        let password: String? = json["password"]
        
        newConnection(url: url, username: username, password: password)

    }
    
    override func show(error: ServerFacade.ErrorType) {
        connecting = false
        
        var alert: UIAlertController!
        
        switch error {
        case .INVALID_QR, .INVALID_URL:
            alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("invalid_qr", comment: ""),
                                      preferredStyle: .alert)
        case .INVALID_USERNAME_OR_PASSWORD:
            alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("invalid_username_password", comment: ""),
                                      preferredStyle: .alert)
        case .NO_CONNECTION, .TIME_OUT:
            alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("no_internet", comment: ""),
                                      preferredStyle: .alert)
        default:
            alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("server_bad_connection", comment: ""),
                                      preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
