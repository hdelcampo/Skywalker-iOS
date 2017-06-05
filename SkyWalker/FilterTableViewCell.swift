//
//  FilterCell.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 31/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

/**
 Switcher delegate protocol.
*/
protocol SwitchCellDelegate {
    
    /**
        Called when a cell has switched.
        - Parameter cell: The cell that changed.
    */
    func onSwitchChange(cell: FilterTableViewCell)
}

/**
 Filter view table cells
*/
class FilterTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    /**
        The data this cell represents.
    */
    weak var cellData: FilterCellData!
    
    // MARK: delegate
    
    /**
        The view's delegate.
    */
    var delegate: SwitchCellDelegate?
    
    // MARK: Outlets actions
    
    /**
        Handler for switch
    */
    @IBAction func onSwitchChange() {
        cellData.enabled = `switch`.isOn
        delegate?.onSwitchChange(cell: self)
    }
    
}
