//
//  EntryViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 6/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import AVFoundation

class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (!hasCameraPermission()) {
            requestCameraPermission()
        }
    }
    
    /**
        Checks whether user has granted camera permissions.
     
        - Returns: True if permissions are granted, false otherwise.
    */
    private func hasCameraPermission() -> Bool {
        return (.authorized ==
            AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo))
    }
    
    private func requestCameraPermission () {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,
                                      completionHandler: { (granted : Bool) -> Void in
                                        if (!granted) {
                                            self.requestCameraPermission()
                                        }
        })
    }

}
