//
//  InformationViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 11/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var buildLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBuildStamp()
    }

    /**
     Sets the build stamp to the UI
     */
    private func setBuildStamp () {
        let dictionary = Bundle.main.infoDictionary!
        let build = dictionary["CFBundleVersion"] as! String
        buildLabel.text = "Build: \(build)"
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
