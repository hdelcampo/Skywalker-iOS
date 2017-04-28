//
//  ViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 24/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import AVFoundation

class ARViewController: UIViewController {
    
    //MARK: SubView controllers
    
    private var overlayViewController: OverlayViewController!
    
    //MARK: Controls properties
    
    private var areControlsHidden = true
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            myDelegate.portraitOnly = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return areControlsHidden
    }
    
    @IBAction func toggleControls(_ sender: UITapGestureRecognizer) {
        areControlsHidden = !areControlsHidden
        
        let ANIMATION_TIME = 0.5
        
        UIView.transition(with: view, duration: ANIMATION_TIME, options: .transitionCrossDissolve,
                          animations: {self.bottomBar.isHidden = self.areControlsHidden; self.topBar.isHidden = self.areControlsHidden},
                          completion: {(_) in self.setNeedsStatusBarAppearanceUpdate()})
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? InformationViewController {
            controller.popoverPresentationController?.delegate = controller
            controller.debugController = overlayViewController
        } else if let controller = segue.destination as? FilterViewController {
            controller.allPoints = PointOfInterest.points!
            controller.usedPoints = overlayViewController.points
            controller.caller = self
        } else if let controller = segue.destination as? OverlayViewController {
            overlayViewController = controller
        }
        
    }
    
    /**
        Log outs and finishes current view
    */
    @IBAction func logout(_ sender: UIBarButtonItem) {
        ServerFacade.instance.clear()
        dismiss(animated: true, completion: nil)
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            myDelegate.portraitOnly = true
        }
    }
    
    /**
        Indicates what points should be drawn.
        - Parameters:
            - points: The list of points to show.
    */
    func show(points: [PointOfInterest]) {
        overlayViewController.points = points
    }
    
}

