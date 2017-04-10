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
    
    //MARK: Controls properties
    
    private var areControlsHidden = true
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var buildLabel: UILabel!
    
    /*
        Thread that handles tags position updating
    */
    let thread: TagsUpdaterThread = TagsUpdaterThread()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBuildStamp()
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
    
    /**
     Sets the build stamp to the UI
     */
    private func setBuildStamp () {
        let dictionary = Bundle.main.infoDictionary!
        let build = dictionary["CFBundleVersion"] as! String
        buildLabel.text = "Build: \(build)"
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

