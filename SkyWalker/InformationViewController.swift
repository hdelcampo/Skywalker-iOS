//
//  InformationViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 11/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

/**
   Controller for connection information view.
 */
class InformationViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    /**
        The container controller.
    */
    var debugController: OverlayViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serverLabel.text = User.instance.token?.URL
        setBuildStamp()
    }

    /**
     Sets the build stamp to the UI
     */
    private func setBuildStamp () {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        buildLabel.text = "Version \(version)\nBuild \(build)"
        switcher.isOn = debugController.debugView.isHidden
        
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func toggleDebug(_ sender: UISwitch) {
        debugController.debugView.isHidden = sender.isOn
    }
    
}
