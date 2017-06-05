//
//  ConnectViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 2/11/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

/**
    New Connection view controller.
*/
class ConnectionDialogController: UITabBarController {

    /**
        Action called when pressed cancel button
        Dismisses view
    */
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
