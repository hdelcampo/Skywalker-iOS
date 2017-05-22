//
//  CameraViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 24/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    // MARK: Properties
    
    let camera = Camera.instance

    // MARK: Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        camera.view = view
        camera.setRearCamera()
        camera.beginSession()
        NotificationCenter.default.addObserver(self, selector: #selector(onBackgroundStateChange(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onBackgroundStateChange(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    /**
        Callback to handle foreground/background changes.
        - Parameters:
            - notification: The notification itself.
    */
    func onBackgroundStateChange(_ notification: NSNotification) {
        switch notification.name {
            case NSNotification.Name.UIApplicationDidBecomeActive:
                camera.resume()
            default:
                camera.pause()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        camera.stopSession()
    }
    
    
    override func viewDidLayoutSubviews() {
        camera.rotate(orientation: UIDevice.current.orientation)
    }
    
}
