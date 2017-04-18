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
class IBeaconTransmitter: NSObject, CBPeripheralManagerDelegate {
    
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
    private let queue: DispatchQueue
    
    /**
        Region ID.
    */
    private let id = "es.rdnest.xtremeloc"
    
    /**
        Singleton instance
    */
    static let instance = IBeaconTransmitter()
    
    // MARK: Init
    
    /**
        Creates a new iBeacon transmitter, operations will be placed on a background serial queue.
    */
    override init() {
        queue = DispatchQueue(label: "Bluetooth queue")
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: queue)
    }
    
    // MARK: Functions
    
    /**
        Set ups a new beacon transmitter with the given values.
        When bluetooth is available, transmission will begin.
        - Parameters:
            - uuid: The UUID.
            - major: The major.
            - minor: The minor.
            - txPower: The measured TX Power, can be nil to use device's default value.
    */
    func configure(frame: IBeaconFrame, txPower: NSNumber? = nil) {
        let localBeacon = CLBeaconRegion(proximityUUID: frame.uuid, major: frame.major, minor: frame.minor, identifier: id)
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: txPower)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch (peripheral.state) {
        case .poweredOn:
            print ("Comenzando...")
            peripheralManager.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
            print ("Comenzado!")
        default:
            print("iBeacon event")
        }
    }
    
    /**
        Stopts the iBeacon transmission.
    */
    func stopTransmission() {
        peripheralManager.stopAdvertising()
    }
    
}
