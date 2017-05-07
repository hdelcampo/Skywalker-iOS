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
        iBeacon frame to transmit.
    */
    private var iBeacon: CLBeaconRegion?
    
    /**
        The txPower to transmit.
    */
    private var txPower: NSNumber?
    
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
        - Parameters:
            - frame: The desired iBeacon frame to transmit.
            - txPower: The measured TX Power, can be nil to use device's default value.
    */
    func configure(frame: IBeaconFrame, txPower: NSNumber? = nil) {
        iBeacon = CLBeaconRegion(proximityUUID: frame.uuid, major: frame.major, minor: frame.minor, identifier: id)
    }
    
    /**
        Starts the iBeacon transmission as soon as bluetooth is available.
    */
    func startTransmission() {
        beaconPeripheralData = iBeacon!.peripheralData(withMeasuredPower: txPower)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn) {
            print("Empezando... \(iBeacon?.minor)")
            peripheralManager.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
            print("Empezado...")
        }
    }
    
    /**
        Stopts the iBeacon transmission.
    */
    func stopTransmission() {
        print("Parando...")
        peripheralManager.stopAdvertising()
        print("Parado...")
    }
    
}
