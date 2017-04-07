//
//  ViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 24/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    /*
        Thread that handles tags position updating
    */
    let thread: TagsUpdaterThread = TagsUpdaterThread()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thread.start()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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

