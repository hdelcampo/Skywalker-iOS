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
    var peripheralManager: CBPeripheralManager?
    
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
        Frame to transmit.
    */
    private(set) var frame: IBeaconFrame?
    
    /**
        The txPower to transmit.
    */
    private var txPower: NSNumber?
    
    /**
        Indicates if an ongoing transmission is on.
    */
    var isTransmitting: Bool {
        
        if peripheralManager == nil {
            return false
        }
        
        return peripheralManager!.isAdvertising
    }
    
    // MARK: Init
    
    /**
        Creates a new iBeacon transmitter, operations will be placed on a background serial queue.
    */
    override init() {
        queue = DispatchQueue(label: "Bluetooth queue")
        super.init()
    }
    
    // MARK: Functions
    
    /**
        Set ups a new beacon transmitter with the given values.
        - Parameters:
            - frame: The desired iBeacon frame to transmit.
            - txPower: The measured TX Power, can be nil to use device's default value.
    */
    func configure(frame: IBeaconFrame, txPower: NSNumber? = nil) {
        self.frame = frame
        iBeacon = CLBeaconRegion(proximityUUID: frame.uuid, major: frame.major, minor: frame.minor, identifier: id)
    }
    
    /**
        Starts the iBeacon transmission as soon as bluetooth is available.
    */
    func startTransmission() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: queue)
        beaconPeripheralData = iBeacon!.peripheralData(withMeasuredPower: txPower)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn) {
            peripheralManager!.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
        }
    }
    
    /**
        Stopts the iBeacon transmission.
    */
    func stopTransmission() {
        peripheralManager!.stopAdvertising()
        peripheralManager!.removeAllServices()
        peripheralManager = nil
    }
    
}
