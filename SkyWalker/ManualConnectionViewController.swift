//
//  ManualConnectionViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 2/11/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class ManualConnectionViewController: UIViewController {

    @IBOutlet weak var uriField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectButton: UIButton!
    
    /**
        Called when connect button is clicked
        Retrieves a new token if possible from server
    */
    @IBAction func newConnection () {
        
        let url = uriField.text!
        let user = userField.text!
        let password = passwordField.text!
        
        guard let _ = URL(string: url) else {
            let alert = UIAlertController (title: "Error", message: "URL is invalid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in alert.dismiss(animated: true, completion: nil) } ))
            return
        }
        
        progressIndicator.startAnimating()
        connectButton.isEnabled = false

        ServerHandler.getToken(completionHandler: {(data, response, error) in
            
            OperationQueue.main.addOperation {
                
            self.progressIndicator.stopAnimating()
            self.connectButton.isEnabled = true
            
            guard error == nil else {
                let alert = UIAlertController (title: "Error", message: "Unknown error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in alert.dismiss(animated: true, completion: nil) } ))
                self.present(alert, animated: true, completion: nil)
                return;
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if (httpResponse.statusCode != 200) {
                    let error = ServerHandler.getError(statusCode: httpResponse.statusCode)
                    let alert = UIAlertController (title: "Error", message: String(describing: error), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in alert.dismiss(animated: true, completion: nil) } ))
                    self.present(alert, animated: true, completion: nil)
                    return;
                }
                
                else {
                    let ARView = self.storyboard?.instantiateViewController(withIdentifier: "AugmentedRealityView")
                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    self.present(ARView!, animated: true, completion: nil)
                }
                
            }
                
            } //End of main operation
        }, url: url, username: user, password: password)
        
    }
    
}
