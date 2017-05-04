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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        camera.view = view
        camera.setRearCamera()
        camera.beginSession()
 
    }
    
    /**
        Callback for view destroy
    */
    func viewWillBeDestroyed() {
        camera.stopSession()
    }
    
    override func viewDidLayoutSubviews() {
        camera.rotate(orientation: UIDevice.current.orientation)
    }

}
