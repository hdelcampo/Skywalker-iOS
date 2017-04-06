//
//  IBeaconTransmitter.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 6/4/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import CoreBluetooth
import CoreLocation

/**
    Beacon tranmission handler class.
 */
class IBeaconTransmitter {
    
    // MARK: Properties
    
    /**
        Data to transmit.
    */
    var beaconPeripheralData: NSDictionary!
    
    /**
        Bluetooth manager.
    */
    var peripheralManager: CBPeripheralManager!
    
    /**
        Serial background queue for all emissions.
    */
    private static let queue = DispatchQueue(label: "Bluetooth queue")
    
    /**
        Region ID.
    */
    private let id = "es.rdnest.xtremeloc"
    
    // MARK: Init
    
    /**
        Creates a new beacon transmitter with the given values.
        Notice that operations will be placed on a background serial queue.
        - Parameters:
            - uuid: The UUID.
            - major: The major.
            - minor: The minor.
            - txPower: The measured TX Power, can be nil to use device's default value.
    */
    init(uuid: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, txPower: NSNumber?) {
        let localBeacon = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: id)
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: txPower)
        peripheralManager = CBPeripheralManager(delegate: nil, queue: IBeaconTransmitter.queue)
    }
    
    // MARK: Functions

    /**
        Starts the iBeacon transmission.
    */
    func startTransmission() {
        peripheralManager.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
    }
    
    /**
        Stopts the iBeacon transmission.
    */
    func stopTransmission() {
        peripheralManager.stopAdvertising()
    }
    
}
