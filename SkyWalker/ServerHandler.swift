//
//  ServerHandler.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 20/2/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

class ServerHandler {
    
    public enum ErrorType {
        case INVALID_USERNAME_OR_PASSWORD, UNKNOWN
    }
    
    /**
        Retrieves a new token
    */
    static func getToken (completionHandler: @escaping (_: Data?, _: URLResponse?, _: Error?) -> Void,
                          url: String, username: String?, password: String?) {
        
        let realUrl = url.appending("/api/authentication")
        
        guard let URL = URL(string: realUrl) else {
            print ("Error \(url) is invalid")
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let params: [String: Any] = ["login" : username!, "password" : password!]
            request.httpBody =
                try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Error: cannot parse JSON")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        
    }
    
    /**
        Retrieves actual server error
        - parameters:
            - statusCode: http status code
    */
    static func getError (statusCode : Int) -> ErrorType {
        
        switch statusCode {
            case 401:
                return .INVALID_USERNAME_OR_PASSWORD
            default:
                return .UNKNOWN
        }
        
    }
    
}
