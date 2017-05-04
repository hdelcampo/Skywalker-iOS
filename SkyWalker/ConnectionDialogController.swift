//
//  ConnectViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 2/11/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class ConnectionDialogController: UITabBarController, UITabBarControllerDelegate {
    
    /**
        The QR tab view controller
    */
    var qrTabController: QRConnectionViewController?
    
    override func viewDidLoad() {
        delegate = self
    }

    /**
        Action called when pressed cancel button
        Dismisses view
    */
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let controller = viewController as? QRConnectionViewController {
            qrTabController = controller
            controller.connecting = false
        } else {
            qrTabController?.connecting = true
        }
    }

}
