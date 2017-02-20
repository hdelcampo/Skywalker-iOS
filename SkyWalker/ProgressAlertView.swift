//
//  ProgressAlertView.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 17/2/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation
import UIKit

class ProgressAlertView {
    
    static func create (message msg: String) -> UIAlertController {
    
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
       // alert.view.tintColor = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF, alpha: 1)
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        return alert
    
    }
    
}
