//
//  ServerHandler.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 20/2/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

class ServerHandler {
    
    public enum ErrorType: Error {
        case INVALID_USERNAME_OR_PASSWORD, NO_TOKEN_SET, SERVER_ERROR, UNKNOWN
    }
    
    var token: Token?
    static let instance: ServerHandler! = ServerHandler()
    
    /**
        Retrieves a new token
    */
    func getToken (url: String, username: String?, password: String?,
                          onSuccess: @escaping (_: Token) -> Void, onError: @escaping (_: ErrorType) -> Void) {
        
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
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
                guard error == nil else {
                    onError(.UNKNOWN)
                    return;
                }
            
                if let httpResponse = response as? HTTPURLResponse {
            
                    if (httpResponse.statusCode != 200) {
                        onError(ServerHandler.getError(statusCode: httpResponse.statusCode))
                    } else {
                        let data = String(data: data!, encoding: String.Encoding.utf8)
                        let token = Token(URL: url, token: data!)
                        ServerHandler.instance.token = token
                        onSuccess(token)
                    }
            
                }
            
        }
            
        )
        
        task.resume()
        
    }
    
    func getAvaliableTags (onSuccess: @escaping (_: [PointOfInterest]) -> Void, onError: @escaping (_: ErrorType) -> Void) throws {
    
        if (nil == token) {
            throw ErrorType.NO_TOKEN_SET
        }
        
        let realURL = token!.URL.appending("/api/centers/0/tags")
        guard let URL = URL(string: realURL) else {
            print ("Error \(realURL) is invalid")
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard error == nil else {
                onError(.UNKNOWN)
                return;
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if (httpResponse.statusCode != 200) {
                    onError(ServerHandler.getError(statusCode: httpResponse.statusCode))
                } else {
                    let jsons = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    var points = [PointOfInterest]()
                    
                    for json in jsons as! [Dictionary<String, Any>]{
                        let id: Int = json["id"] as! Int
                        let name: String = json["name"] as! String
                        let point = PointOfInterest(id: id, name: name)
                        points.append(point)
                    }
                    
                    onSuccess(points)
                }
                
            }
            
        }
            
        )
        
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
            case 500:
                return .SERVER_ERROR
            default:
                return .UNKNOWN
        }
        
    }
    
}
