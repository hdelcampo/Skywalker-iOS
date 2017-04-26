//
//  Token.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 20/2/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 Connection info.
 - author: Hector Del Campo Pando
*/
class Token {
    
    let URL : String
    let token : String?
    
    /**
        Unique constructor.
        - parameters:
            - URL: URL of the server.
            - token: token of the connection.
    */
    init (URL : String, token : String?) {
        self.URL = URL
        self.token = token
    }
    
}
