//
//  DataValidator.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 8/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 String extension with some utilites.
*/
extension String {
    
    /**
        Checks whether given parameter is a valid URL or not.
        - Returns: True if valid URL, false otherwise.
    */
    var isValidURL: Bool {
        
        let types: NSTextCheckingResult.CheckingType = .link
        
        let detector = try? NSDataDetector(types: types.rawValue)
        
        let matches = detector?.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, characters.count))
        
        return matches!.count != 0
        
    }
}
