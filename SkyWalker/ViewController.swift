//
//  ViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 24/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func checkCameraPermission() {
        if (AVAuthorizationStatus.authorized ==
            AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ) {
            
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,
                                          completionHandler: { (granted : Bool) -> Void in
                                            if (true == granted){
                                                
                                            } else {
                                                
                                            }
            });

        }
        
    }

}

