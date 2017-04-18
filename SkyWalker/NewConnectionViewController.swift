//
//  NewConnectionViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 7/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

/**
 Base class for new connection view controllers.
 */
class NewConnectionViewController: UIViewController {
    
    // MARK: Properties
    var alert: UIAlertController!
    var indicator: UIActivityIndicatorView!
    
    // MARK: Functions

    /**
        Starts a new connection.
        - Parameters:
            - url: The server url.
            - username: Username for the login.
            - password: Password for the login.
     */
    func newConnection (url: String, username: String?, password: String?) {
        
        alert = UIAlertController(title: nil, message: "Connecting...", preferredStyle: .alert)
        indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = false
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.startAnimating()
        alert.view.addSubview(indicator)
        present(alert, animated: true, completion: nil)
        
        let onSuccess: (Token) -> Void = {_ in
            self.retrieveReceivers()
        }
        
        let onError: (ServerFacade.ErrorType) -> Void = {error in
            DispatchQueue.main.sync {
                self.show(error: error)
            }
        }
        
        ServerFacade.instance.getToken(url: url, username: username, password: password, onSuccess: onSuccess, onError: onError)
        
    }
    
    /**
     Retrieves the avaliable receivers for a center.
     */
    private func retrieveReceivers () {
        
        Center.centers.append(Center(id: 0))
        
        DispatchQueue.main.sync {
            self.alert.message = "Retrieving receivers..."
        }
        
        let onSuccess: ([MapPoint]) -> Void = {receivers in
            Center.centers[0].receivers = receivers
            self.retrieveTags()
        }
        
        let onError: (ServerFacade.ErrorType) -> Void = {error in
            DispatchQueue.main.sync {
                self.show(error: error)
            }
        }
        
        try! ServerFacade.instance.getCenterReceivers(center: Center.centers[0], onSuccess: onSuccess, onError: onError)
        
    }
    
    /**
     Retrieves the avaliable tags from the server.
     */
    private func retrieveTags () {
        
        DispatchQueue.main.sync {
            self.alert.message = "Retrieving tags..."
        }
        
        let onSuccess: ([PointOfInterest]) -> Void = {points in
            DispatchQueue.main.sync {
                PointOfInterest.points = points
                self.alert.dismiss(animated: true, completion: nil)
                self.startAR()
            }
        }
        
        let onError: (ServerFacade.ErrorType) -> Void = {error in
            DispatchQueue.main.sync {
                self.show(error: error)
            }
        }
        
        try! ServerFacade.instance.getAvaliableTags(onSuccess: onSuccess, onError: onError)
        
    }
    
    /**
        Starts the Augmented Reality interface on a new view if caller is not the dialog.
     */
    func startAR () {
                
        if !(self.parent! is ConnectionDialogController) {
            let ARView = self.storyboard?.instantiateViewController(withIdentifier: "AugmentedRealityView")
            self.present(ARView!, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    /**
        Shows an error to the user.
        Must be implemented by inheritors.
    */
    func show(error: ServerFacade.ErrorType) {
        preconditionFailure("Not implemented")
    }

}
