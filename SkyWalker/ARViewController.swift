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
    
    /*
        Thread that handles tags position updating
    */
    let thread: TagsUpdaterThread = TagsUpdaterThread()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thread.start()
    }
    
    override var prefersStatusBarHidden: Bool {
        return areControlsHidden
    }
    
    @IBAction func toggleControls(_ sender: UITapGestureRecognizer) {
        areControlsHidden = !areControlsHidden
        setNeedsStatusBarAppearanceUpdate()
        bottomBar.isHidden = areControlsHidden
        topBar.isHidden = areControlsHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? InformationViewController {
            controller.popoverPresentationController?.delegate = controller
        } else if let controller = segue.destination as? FilterViewController {
            controller.allPoints = PointOfInterest.points!
            controller.usedPoints = overlayViewController.points
            controller.caller = self
        } else if let controller = segue.destination as? OverlayViewController {
            overlayViewController = controller
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
    
    /*
        Thread class to handle tags updating
    */
    class TagsUpdaterThread: Thread {
        
        let updateRate: UInt32 = 1 //seconds
        
        override func main() {
            
            while(self.isExecuting) {
                
                let points = PointOfInterest.points
                
                for point in points! {
                    try? ServerFacade.instance.getLastPosition(tag: point,
                                                                onSuccess: {(_) in },
                                                                onError: { (error) in print("Error ocurred during update: \(String(describing: error))" )})
                }
                
                sleep(updateRate)
                
            }
            
        }
        
    }

}

