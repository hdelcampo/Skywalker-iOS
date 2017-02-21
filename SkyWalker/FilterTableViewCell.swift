//
//  FilterCell.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 31/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func onSwitchChange(cell: FilterTableViewCell)
}

/**
 Filter view table cells
*/
class FilterTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    // MARK: delegate
    var delegate: SwitchCellDelegate?
    
    // MARK: Outlets actions
    
    /**
        Handler for switch
    */
    @IBAction func onSwitchChange() {
        delegate?.onSwitchChange(cell: self)
    }
    
}
