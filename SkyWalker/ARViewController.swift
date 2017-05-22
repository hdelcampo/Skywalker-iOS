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
    
    private var cameraViewController: CameraViewController!
    
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
        
        let hide: (Bool) -> Void = { _ in
            self.bottomBar.isHidden = self.areControlsHidden
            self.topBar.isHidden = self.areControlsHidden
        }
        
        if !areControlsHidden {
            hide(true)
        }

        UIView.animate(withDuration: ANIMATION_TIME,
                       delay: 0,
                       options: UIViewAnimationOptions.transitionCrossDissolve,
                       animations: {
                        self.bottomBar.alpha = self.areControlsHidden ? 0 : 1
                        self.topBar.alpha = self.areControlsHidden ? 0 : 1
                        self.setNeedsStatusBarAppearanceUpdate()
        }, completion: areControlsHidden ? hide : nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? InformationViewController {
            controller.popoverPresentationController?.delegate = controller
            controller.debugController = overlayViewController
        } else if let controller = segue.destination as? FilterViewController {
            controller.allPoints = User.instance.center!.points!
            controller.usedPoints = overlayViewController.points
            controller.caller = self
        } else if let controller = segue.destination as? OverlayViewController {
            overlayViewController = controller
        } else if let controller = segue.destination as? CameraViewController {
            cameraViewController = controller
        }
        
    }
    
    /**
        Log outs and finishes current view
    */
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            myDelegate.portraitOnly = true
        }
        dismiss(animated: true, completion: nil)

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

