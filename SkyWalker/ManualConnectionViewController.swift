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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ManualConnectionViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ManualConnectionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    /**
        Called when connect button is clicked
        Retrieves a new token if possible from server
    */
    @IBAction func newConnection () {
        
        let url = uriField.text!
        let user = userField.text!
        let password = passwordField.text!
        
        if url == "demo" {
            PointOfInterest.points = PointOfInterest.getDemoPoints()
            startAR()
            return
        }
        
        guard let _ = URL(string: url) else {
            let alert = UIAlertController (title: "Error", message: "URL is invalid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in alert.dismiss(animated: true, completion: nil) } ))
            return
        }
        
        progressIndicator.startAnimating()
        connectButton.isEnabled = false
        
        let onSuccess: (Token) -> Void = {_ in
            self.retrieveTags()
        }
        
        let onError: (ServerHandler.ErrorType) -> Void = {error in
            OperationQueue.main.addOperation {
                self.progressIndicator.stopAnimating()
                self.connectButton.isEnabled = true
                let alert = UIAlertController (title: "Error", message: String(describing: error), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in alert.dismiss(animated: true, completion: nil) } ))
                self.present(alert, animated: true, completion: nil)
            }
        }

        ServerHandler.instance.getToken(url: url, username: user, password: password, onSuccess: onSuccess, onError: onError)
        
    }
    
    /*
        Retrieves the avaliable tags from the server
    */
    private func retrieveTags () {
        
        let onSuccess: ([PointOfInterest]) -> Void = {points in
            OperationQueue.main.addOperation {
                PointOfInterest.points = points
                self.startAR()
            }
        }
        
        let onError: (ServerHandler.ErrorType) -> Void = {error in
            OperationQueue.main.addOperation {
                self.progressIndicator.stopAnimating()
                self.connectButton.isEnabled = true
                let alert = UIAlertController (title: "Error", message: String(describing: error), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in alert.dismiss(animated: true, completion: nil) } ))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        try! ServerHandler.instance.getAvaliableTags(onSuccess: onSuccess, onError: onError)
        
    }
    
    /*
        Starts the Augmented Reality interface on a new view if caller is not the dialog
    */
    private func startAR () {
        
        if !(self.parent! is ConnectionDialogController) {
            let ARView = self.storyboard?.instantiateViewController(withIdentifier: "AugmentedRealityView")
            self.present(ARView!, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
