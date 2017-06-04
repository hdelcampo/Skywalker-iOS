//
//  Center.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 16/3/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

/**
 XtremeLoc center.
*/
class Center {
    
    /**
        Center's id.
    */
    let id: Int
    
    /**
        Map scale
    */
    var scale: Double = 40

    /**
     Map north offset
    */
    private(set) var mapNorthOffset: Double
    
    /**
        List of antennas.
    */
    var receivers: [MapPoint]?
    
    /**
        List of points.
    */
    var points: [PointOfInterest]?
    
    /**
        Unique constructor.
        - Parameters:
            - id: Center id.
            - northOffset: Map north offset in degrees.
    */
    init(id: Int, northOffset: Double) {
        self.id = id
        self.mapNorthOffset = northOffset
    }
    
    /**
        Retrieves receivers from persistence system.
        - Parameters:
            - successDelegate: Success callback.
            - errorDelegate: Error callback.
    */
    func loadReceivers(successDelegate: (() -> Void)?,
                       errorDelegate: ((PersistenceErrors) -> Void)?) {
        
        let onSuccess: ([MapPoint]) -> Void = {receivers in
            self.receivers = receivers
            self.scale = 128
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
        
        try! ServerFacade.instance.getCenterReceivers(center: id, onSuccess: onSuccess, onError: onError)
    }
    
    /**
     Retrieves beacons from persistence system.
        - Parameters:
            - successDelegate: Success callback.
            - errorDelegate: Error callback.
     */
    func loadTags(successDelegate: (() -> Void)?,
                       errorDelegate: ((PersistenceErrors) -> Void)?) {
        
        let onSuccess: ([PointOfInterest]) -> Void = {points in
            
            self.points = points
            for (index, point) in self.points!.enumerated() {
                if (User.instance.position == point) {
                    self.points?.remove(at: index)
                }
            }
            
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
        
        try! ServerFacade.instance.getAvaliableTags(onSuccess: onSuccess, onError: onError)
    }
    
}
