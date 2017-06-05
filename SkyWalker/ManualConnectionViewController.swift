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
    
    // MARK: Outlets
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var urlContainer: UIView!
    @IBOutlet weak var userContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var demoButton: UIButton!
    
    @IBOutlet weak var errURL: UILabel!
    @IBOutlet weak var errUsername: UILabel!
    @IBOutlet weak var errPassword: UILabel!
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectButton.layer.borderColor = connectButton.tintColor.cgColor
        demoButton.layer.borderColor = demoButton.tintColor.cgColor
        
        urlField.delegate = self
        userField.delegate = self
        passwordField.delegate = self
        
        addCircleCorner(view: errURL)
        addCircleCorner(view: errUsername)
        addCircleCorner(view: errPassword)
        
        toggleError(view: urlContainer, error: false)
        toggleError(view: userContainer, error: false)
        toggleError(view: passwordContainer, error: false)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
        Demo mode click.
    */
    @IBAction func startDemo() {
        User.instance.isDemo = true
        User.instance.center = Center(id: 0, northOffset: 5)
        User.instance.center!.points = PointOfInterest.demoPoints
        User.instance.center!.scale = 50
        startAR()
    }
    
    /**
        Accept click
    */
    @IBAction func connectClick() {
        let url = urlField.text!
        let user = userField.text!
        let password = passwordField.text!
        
        if (url.isEmpty) {
            toggleError(view: urlContainer, error: true, errorMsg: NSLocalizedString("invalid_url", comment: ""))
            connectButton.isEnabled = false
        }
        
        guard let _ = URL(string: url) else {
            let alert = UIAlertController (title: "Error", message: NSLocalizedString("invalid_url", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil ))
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
        
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.red.cgColor
        
        if !error {
            view.layer.borderWidth = 0
            view.viewWithTag(1)?.isHidden = true
            view.viewWithTag(2)?.isHidden = true
        } else {
            view.layer.borderWidth = 1
            view.viewWithTag(1)?.isHidden = false
            view.viewWithTag(2)?.isHidden = false
            (view.viewWithTag(2) as! UILabel).text = errorMsg
        }
        
    }
    
    override func show(error: PersistenceErrors) {
        
        switch error {
        case .INVALID_URL:
            alert.dismiss(animated: true, completion: nil)
            toggleError(view: urlContainer, error: true, errorMsg: NSLocalizedString("invalid_url", comment: ""))
            connectButton.isEnabled = false
        case .INVALID_CREDENTIALS:
            alert.dismiss(animated: true, completion: nil)
            toggleError(view: userContainer, error: true, errorMsg: NSLocalizedString("invalid_username_password", comment: ""))
            toggleError(view: passwordContainer, error: true, errorMsg: NSLocalizedString("invalid_username_password", comment: ""))
        case .INTERNET_ERROR:
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
            indicator.removeFromSuperview()
            alert.message = NSLocalizedString("no_internet", comment: "")
        default:
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
            indicator.removeFromSuperview()
            alert.message = NSLocalizedString("server_bad_connection", comment: "")
        }
        
    }
    
    /**
        Adds a red circle border to the given view.
        - Parameters:
            - view: The view to modify.
    */
    private func addCircleCorner(view: UIView) {
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.cornerRadius = view.frame.size.width / 2
    }
    
    // MARK: UITextFieldDelegate funcs
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if (textField != urlField) {
            return true
        }
        
        let url = textField.text!.appending(string)
        
        if (url.isValidURL) {
            toggleError(view: urlContainer, error: false)
            connectButton.isEnabled = true
        } else {
            toggleError(view: urlContainer, error: true, errorMsg: NSLocalizedString("invalid_url", comment: ""))
            connectButton.isEnabled = false
        }
        
        return true
    }
    
}
