//
//  User.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 12/5/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 XtremeLoc system user.
*/
class User {
    
    /**
     Singleton instance.
     */
    static let instance = User()
    
    /**
        User's token.
    */
    private(set) var token: Token?
    
    /**
        Centers where user is registered.
    */
    var center: Center?
    
    /**
        Bluetooth transmitter.
    */
    let transmitter = IBeaconTransmitter()
    
    /**
        Position on map.
    */
    private(set) var position: MapPoint?
    
    /**
        User's username.
    */
    private(set) var username: String?
    
    /**
        Indicates whether connection is in demo mode or not
     */
    var isDemo: Bool {
        
        get {
            return token?.URL == NSLocalizedString("Demo_mode", comment: "")
        }
        
        set {
            token = Token(URL: NSLocalizedString("Demo_mode", comment: ""), token: nil)
        }
        
    }
    
    /**
        Logs this user on the server.
        - Parameters:
            - server: The server where to log in.
            - username: Of the user.
            - password: Of the user.
            - successDelegate: Success callback.
            - errorDelegate: Error delegate.
    */
    func login(server: String,
               username: String?,
               password: String?,
               successDelegate: (() -> Void)?,
               errorDelegate: ((PersistenceErrors) -> Void)?) {
        
        let onSuccess: (Token) -> Void = {token in
            self.token = token
            self.username = username
            self.center = Center(id: 0, northOffset: 5)
            successDelegate?()
        }
        
        let onError: (ServerFacade.ErrorType) -> Void = {error in
            let realError: PersistenceErrors
            
            switch(error) {
            case .INVALID_USERNAME_OR_PASSWORD:
                realError = .INVALID_CREDENTIALS
            case .NO_CONNECTION, .TIME_OUT:
                realError = .INTERNET_ERROR
            default:
                realError = .SERVER_ERROR
            }
            
            errorDelegate?(realError)
            
        }
        
        ServerFacade.instance.getToken(url: server, username: username, password: password, onSuccess: onSuccess, onError: onError)
        
    }
    
    /**
        Logouts the user from the remote connection.
    */
    func logout() {
        token = nil
    }
    
    /**
        Registers this device as beacon.
        - Parameters:
            - successDelegate: Success callback.
            - errorDelegate: Error callback.
    */
    func registerBeacon(successDelegate: (() -> Void)?,
                        errorDelegate: ((PersistenceErrors) -> Void)?) {
        
        let onSuccess: (IBeaconFrame) -> Void = {frame in
            self.transmitter.configure(frame: frame)
            self.position = MapPoint(id: Int(frame.minor), x: -1, y: -1, z: -1)
            successDelegate?()
        }
        
        let onError: (ServerFacade.ErrorType) -> Void = {error in
            
            let realError: PersistenceErrors
            
            switch(error) {
            case .NO_CONNECTION, .TIME_OUT:
                realError = .INTERNET_ERROR
            default:
                realError = .SERVER_ERROR
            }
            
            errorDelegate?(realError)
            
        }
        
        try! ServerFacade.instance.registerAsBeacon(username: username!,
                                                    onSuccess: onSuccess,
                                                    onError: onError)
        
    }
    
}
