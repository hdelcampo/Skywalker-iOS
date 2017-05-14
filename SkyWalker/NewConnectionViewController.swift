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
        
        alert = UIAlertController(title: nil,
                                  message: NSLocalizedString("connection_started", comment: ""),
                                  preferredStyle: .alert)
        indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = false
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.startAnimating()
        alert.view.addSubview(indicator)
        present(alert, animated: true, completion: nil)
        
        let onSuccess: () -> Void = {_ in
            self.registerAsBeacon(username: username!)
        }
        
        let onError: (PersistenceErrors) -> Void = {error in
            DispatchQueue.main.sync {
                self.show(error: error)
            }
        }
        
        User.instance.login(server: url, username: username, password: password, successDelegate: onSuccess, errorDelegate: onError)
        
    }
    
    /**
     Retrieves the avaliable receivers for a center.
     */
    private func retrieveReceivers () {
        
        Center.centers.append(Center(id: 0))
        
        DispatchQueue.main.sync {
            self.alert.message = NSLocalizedString("connection_receivers", comment: "")
        }
        
        let onSuccess: () -> Void = {_ in
            self.retrieveTags()
        }
        
        let onError: (PersistenceErrors) -> Void = {error in
            DispatchQueue.main.sync {
                self.show(error: error)
            }
        }
        
        Center.centers[0].loadReceivers(successDelegate: onSuccess, errorDelegate: onError)
        
    }
    
    /**
     Retrieves the avaliable tags from the server.
     */
    private func retrieveTags () {
        
        DispatchQueue.main.sync {
            self.alert.message = NSLocalizedString("connection_tags", comment: "")
        }
        
        let onSuccess: () -> Void = {_ in
            DispatchQueue.main.sync {
                self.alert.dismiss(animated: true, completion: nil)
                self.startAR()
            }
        }
        
        let onError: (PersistenceErrors) -> Void = {error in
            DispatchQueue.main.sync {
                self.show(error: error)
            }
        }
        
        Center.centers[0].loadTags(successDelegate: onSuccess, errorDelegate: onError)
        
    }
    
    private func registerAsBeacon(username: String) {
        
        DispatchQueue.main.sync {
            self.alert.message = NSLocalizedString("connection_register_beacon", comment: "")
        }
        
        let onSuccess: () -> Void = {_ in
            self.retrieveReceivers()
        }
        
        let onError: (PersistenceErrors) -> Void = {error in
            DispatchQueue.main.sync {
                self.show(error: error)
            }
        }
        
        User.instance.registerBeacon(successDelegate: onSuccess, errorDelegate: onError)
    }
    
    /**
        Starts the Augmented Reality interface.
     */
    func startAR () {
                
        let ARView = self.storyboard?.instantiateViewController(withIdentifier: "AugmentedRealityView")
        self.present(ARView!, animated: true, completion: nil)
        
    }
    
    /**
        Shows an error to the user.
        Must be implemented by inheritors.
    */
    func show(error: PersistenceErrors) {
        preconditionFailure("Not implemented")
    }

}
