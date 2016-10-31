//
//  FilterCell.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 31/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func onSwitchChange(cell: FilterCell)
}

class FilterCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
        Handler for switch
    */
    @IBAction func onSwitchChange(_ sender: UISwitch) {
        delegate?.onSwitchChange(cell: self)
    }
}
