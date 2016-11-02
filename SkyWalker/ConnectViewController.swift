//
//  ConnectViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 2/11/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {

    
    @IBOutlet weak var QRContainer: UIView!
    @IBOutlet weak var ManualContainer: UIView!
    
    
    @IBAction func SliderChanged(_ sender: UISegmentedControl) {
        if (0 == sender.selectedSegmentIndex) {
            ManualContainer.alpha = 0
            QRContainer.alpha = 1
        } else {
            ManualContainer.alpha = 1
            QRContainer.alpha = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
