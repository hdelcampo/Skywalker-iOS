//
//  ServerHandler.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 20/2/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

class ServerFacade {
    
    /*
     Possible errors
    */
    public enum ErrorType: Error {
        case INVALID_QR, INVALID_USERNAME_OR_PASSWORD, NO_TOKEN_SET, SERVER_ERROR, UNKNOWN
    }
    
    /*
        Connection token
    */
    var token: Token?
    
    /*
        Singleton instance
    */
    static let instance: ServerFacade! = ServerFacade()
    
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
                        onError(ServerFacade.getError(statusCode: httpResponse.statusCode))
                    } else {
                        let data = String(data: data!, encoding: String.Encoding.utf8)
                        let token = Token(URL: url, token: data!)
                        ServerFacade.instance.token = token
                        onSuccess(token)
                    }
            
                }
            
        }
            
        )
        
        task.resume()
        
    }
    
    /**
     Retrieves a center's receivers
     */
    func getCenterReceivers (center: Center,
                             onSuccess: @escaping (_: [MapPoint]) -> Void,
                             onError: @escaping (_: ErrorType) -> Void) throws {
        
        if (nil == token) {
            throw ErrorType.NO_TOKEN_SET
        }
        
        let realURL = token!.URL.appending("/api/centers/\(center.id)/rdhubs")
        guard let URL = URL(string: realURL) else {
            print ("Error \(realURL) is invalid")
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.token!.token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard error == nil else {
                onError(.UNKNOWN)
                return;
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if (httpResponse.statusCode != 200) {
                    onError(ServerFacade.getError(statusCode: httpResponse.statusCode))
                } else {
                    let jsons = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    var receivers = [MapPoint]()
                    
                    for json in jsons as! [Dictionary<String, Any>]{
                        let id: Int = json["id"] as! Int
                        let x: Double = json["x"] as! Double
                        let y: Double = json["y"] as! Double
                        let z: Int = json["z"] as! Int
                        let receiver = MapPoint(id: id, x: x, y: y, z: z)
                        receivers.append(receiver)
                    }
                    
                    onSuccess(receivers)
                }
                
            }
            
        }
            
        )
        
        task.resume()
        
    }

    
    /*
        Retrieves the avaliable tags for the token in use
    */
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
        request.addValue("Bearer \(self.token!.token)", forHTTPHeaderField: "Authorization")
                
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard error == nil else {
                onError(.UNKNOWN)
                return;
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if (httpResponse.statusCode != 200) {
                    onError(ServerFacade.getError(statusCode: httpResponse.statusCode))
                } else {
                    let jsons = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                    var points = [PointOfInterest]()
                    
                    for json in jsons as! [Dictionary<String, Any>]{
                        let id: Int = json["id"] as! Int
                        let name: String = json["name"] as? String ?? "Unknown"
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
    
    /*
     Registers this device as an iBeacon transmitter
     */
    func registerAsBeacon (username: String,
                           onSuccess: @escaping (_: IBeaconFrame) -> Void,
                           onError: @escaping (_: ErrorType) -> Void) throws {
        
        if (nil == token) {
            throw ErrorType.NO_TOKEN_SET
        }
        
        let realURL = token!.URL.appending("/api/centers/0/tags")
        guard let URL = URL(string: realURL) else {
            print ("Error \(realURL) is invalid")
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.token!.token)", forHTTPHeaderField: "Authorization")
        
        do {
            let params: [String: String] = ["name" : username]
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
                    onError(ServerFacade.getError(statusCode: httpResponse.statusCode))
                } else {
                    let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                    
                    let uuid: UUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!//UUID(uuidString: json["uuid"] as! String)!
                    let major: Int = json["major"] as! Int
                    let minor: Int = json["minor"] as! Int
                    
                    let frame = IBeaconFrame(uuid: uuid, major: major, minor: minor)
                    
                    onSuccess(frame)
                }
                
            }
            
        }
            
        )
        
        task.resume()
        
    }
    
    /*
        Retrieves a point of interest last position
    */
    func getLastPosition(tag: PointOfInterest,
                         onSuccess: @escaping (_: PointOfInterest) -> Void,
                         onError: @escaping (_: ErrorType) -> Void) throws {
        
        if (nil == token) {
            throw ErrorType.NO_TOKEN_SET
        }
        
        let realURL = token!.URL.appending("/api/centers/0/tags/\(tag.id)")
        guard let URL = URL(string: realURL) else {
            print ("Error \(realURL) is invalid")
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.token!.token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard error == nil else {
                onError(.UNKNOWN)
                return;
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if (httpResponse.statusCode != 200) {
                    onError(ServerFacade.getError(statusCode: httpResponse.statusCode))
                } else {
                    let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                    if nil == json["x"] {
                        return
                    }
                    
                    let newPosition = PointOfInterest(id: tag.id, name: tag.name)
                    
                    newPosition.x = json["x"] as! Double
                    newPosition.y = json["y"] as! Double
                    newPosition.z = json["z"] as! Int
                    
                    onSuccess(newPosition)
                }
                
            }
            
        }
            
        )
        
        task.resume()
        
    }
    
    /*
        Clears the current connection.
    */
    func clear () {
        token = nil
    }
    
    /*
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
