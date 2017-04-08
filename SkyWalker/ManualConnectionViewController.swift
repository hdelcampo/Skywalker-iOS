//
//  ManualConnectionViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 2/11/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

/**
 Class to control manual connection view.
 */
class ManualConnectionViewController: NewConnectionViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var urlContainer: UIView!
    @IBOutlet weak var userContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    
    @IBOutlet weak var connectButton: UIButton!
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleError(view: urlContainer, error: false)
        toggleError(view: userContainer, error: false)
        toggleError(view: passwordContainer, error: false)
        urlField.delegate = self
    }
    
    /**
        Demo mode click.
    */
    @IBAction func startDemo() {
        PointOfInterest.points = PointOfInterest.getDemoPoints()
        startAR()
    }
    
    /**
        Accept click
    */
    @IBAction func connectClick() {
        let url = urlField.text!
        let user = userField.text!
        let password = passwordField.text!
        
        guard let _ = URL(string: url) else {
            let alert = UIAlertController (title: "Error", message: "URL is invalid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in alert.dismiss(animated: true, completion: nil) } ))
            return
        }
        
        newConnection(url: url, username: user, password: password)
    }
    
    /**
        Toggles the error on the given view, notice it must contain a label with tag 2, and an error image with tag 1
        - Parameters:
            - view: The view to manage.
            - error: Whether to show an error or not.
            - errorMsg: The message to show as an error.
    */
    private func toggleError(view: UIView, error: Bool, errorMsg: String = "") {
        
        if !error {
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.darkGray.cgColor
            view.viewWithTag(1)?.isHidden = true
            view.viewWithTag(2)?.isHidden = true
        } else {
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.red.cgColor
            view.viewWithTag(1)?.isHidden = false
            view.viewWithTag(2)?.isHidden = false
            (view.viewWithTag(2) as! UILabel).text = errorMsg
        }
        
    }
    
    override func show(error: ServerFacade.ErrorType) {
        
        switch error {
        case .INVALID_USERNAME_OR_PASSWORD:
            alert.dismiss(animated: true, completion: nil)
            toggleError(view: userContainer, error: true, errorMsg: "Invalid username or password.")
            toggleError(view: passwordContainer, error: true, errorMsg: "Invalid username or password.")
        case .SERVER_ERROR:
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
            indicator.removeFromSuperview()
            alert.message = "A server error ocurred"
        default:
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
            indicator.removeFromSuperview()
            alert.message = "An error ocurred during the connection"
        }
        
    }
    
    // MARK: UITextFieldDelegate funcs
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let url = textField.text!.appending(string)
        
        if (DataValidator.isValidURL(url: url)) {
            toggleError(view: urlContainer, error: false)
            connectButton.isEnabled = true
        } else {
            toggleError(view: urlContainer, error: true, errorMsg: "Invalid URL")
            connectButton.isEnabled = false
        }
        
        return true
    }
    
}
