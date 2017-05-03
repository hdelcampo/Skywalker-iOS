//
//  FilterViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 31/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

/**
 Filter view controller
*/
class FilterViewController: UIViewController, SelectableTableViewDelegate {
    
    //MARK: Properties
    var caller: ARViewController!
    var allPoints = [PointOfInterest]()
    var usedPoints = [PointOfInterest]()
    var tableViewController : FilterTableViewController!
    
    @IBOutlet weak var itemCountLabel: UILabel!

    
    // MARK: Overrides
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? FilterTableViewController {
            tableViewController = controller
            tableViewController.delegate = self
            tableViewController.loadData(allPoints: allPoints, usedPoints: usedPoints)
        }
        
    }
    
    //MARK: Outlets actions
    
    /**
        Dismisses the filter view
    */
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    /**
        Sets the selected points to be shown in the augmented reality overlay
    */
    @IBAction func accept() {
        
        let enabledPoints = tableViewController.getSelectedItems()
        
        caller.show(points: enabledPoints)
        dismiss(animated: true, completion: nil)
        
    }
    
    /**
        Unselects all elements in the points list
    */
    @IBAction func unselectAll() {
        tableViewController.unselectAll()
    }
    
    // MARK: Selectable Table Delegate
    
    func onSelectedCountChange(_ itemCount: Int) {
        itemCountLabel.text = String(format: NSLocalizedString("selectable_table_count_msg", comment: ""),
                                     itemCount, OverlayViewController.maxPoints)
    }

}
