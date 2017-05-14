//
//  User.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 12/5/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

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
        User's username.
    */
    private(set) var username: String?
    
    /**
        Computed property to indicate whether connection is in demo mode or not
     */
    var isDemo: Bool {
        
        get {
            return token?.URL == NSLocalizedString("Demo_mode", comment: "")
        }
        
        set {
            token = Token(URL: NSLocalizedString("Demo_mode", comment: ""), token: nil)
        }
        
    }
    
    func login(server: String,
               username: String?,
               password: String?,
               successDelegate: (() -> Void)?,
               errorDelegate: ((PersistenceErrors) -> Void)?) {
        
        let onSuccess: (Token) -> Void = {token in
            self.token = token
            self.username = username
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
    */
    func registerBeacon(successDelegate: (() -> Void)?,
                        errorDelegate: ((PersistenceErrors) -> Void)?) {
        
        let onSuccess: (IBeaconFrame) -> Void = {frame in
            IBeaconTransmitter.instance.configure(frame: frame)
            PointOfInterest.mySelf = PointOfInterest(id: Int(frame.minor), name: self.username!)
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
