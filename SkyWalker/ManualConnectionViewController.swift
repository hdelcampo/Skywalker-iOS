//
//  ManualConnectionViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 2/11/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class ManualConnectionViewController: NewConnectionViewController {

    @IBOutlet weak var uriField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    /**
        Demo mode click.
    */
    @IBAction func startDemo() {
        PointOfInterest.points = PointOfInterest.getDemoPoints()
        startAR()
    }
    
    @IBAction func connectClick() {
        let url = uriField.text!
        let user = userField.text!
        let password = passwordField.text!
        
        guard let _ = URL(string: url) else {
            let alert = UIAlertController (title: "Error", message: "URL is invalid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in alert.dismiss(animated: true, completion: nil) } ))
            return
        }
        
        newConnection(url: url, username: user, password: password)
    }
    
    override func show(error: ServerFacade.ErrorType) {
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
        indicator.removeFromSuperview()
        
        switch error {
        case .SERVER_ERROR:
            alert.message = "A server error ocurred"
        default:
            alert.message = "An error ocurred during the connection"
        }
        
    }
    
}
