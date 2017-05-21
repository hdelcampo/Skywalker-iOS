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
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        camera.stopSession()
    }
    
    
    override func viewDidLayoutSubviews() {
        camera.rotate(orientation: UIDevice.current.orientation)
    }

}
