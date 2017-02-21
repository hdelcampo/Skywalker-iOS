//
//  FilterCellData.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 31/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
    Filter cell data class
*/
class FilterCellData {
    
    // MARK: Properties
    var enabled: Bool
    var title: String
    
    // MARK: Constructors
    
    init(title: String, enabled: Bool) {
        self.enabled = enabled
        self.title = title
    }
    
}
