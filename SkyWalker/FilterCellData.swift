//
//  FilterCellData.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 31/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
    Filter cell data class.
*/
class FilterCellData {
    
    // MARK: Properties
    
    /**
        Indicates if checkbox is enabled or not.
    */
    var enabled: Bool
    
    /**
        The text being shown.
    */
    var title: String
    
    /**
        The point represented.
    */
    let point: PointOfInterest
    
    // MARK: Constructors

    /**
        Constructs a new table cell.
        - Parameters:
            - point: The item to show.
            - title: The text to show.
            - enabled: The checkbox status.
    */
    init(point: PointOfInterest, title: String, enabled: Bool) {
        self.point = point
        self.enabled = enabled
        self.title = title
    }
    
}
