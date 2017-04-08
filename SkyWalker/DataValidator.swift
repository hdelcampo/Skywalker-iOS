//
//  DataValidator.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 8/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 Helper class to check certain data against a scheme
*/
class DataValidator {
    
    /**
        Checks whether given parameter is a valid URL or not.
        - Parameters:
            - url: Url to check.
        - Returns: True if valid URL, false otherwise.
    */
    static func isValidURL(url: String) -> Bool {
        
        let types: NSTextCheckingResult.CheckingType = .link
        
        let detector = try? NSDataDetector(types: types.rawValue)
        
        let matches = detector?.matches(in: url, options: .reportCompletion, range: NSMakeRange(0, url.characters.count))
        
        return matches!.count != 0
        
    }
}
