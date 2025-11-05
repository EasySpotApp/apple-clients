//
//  DeviceStore.swift
//  EasySpot
//
//  Created by Tymek on 29/10/2025.
//

import Foundation
import CoreBluetooth
import AsyncBluetooth

@MainActor
class DeviceStore: ObservableObject {
    @Published private(set) var pairedDevices: [Device] = []
    @Published private(set) var otherDevices: [Device] = []
    private var deviceMap: [UUID: Device] = [:]
    
    func update(device: Device) {
        print("Adding device \(device.id) \(device.name ?? "no name") \(device.peripheral.state)")
        deviceMap[device.id] = device
        
        pairedDevices = Array(deviceMap.values)
            .filter { $0.peripheral.state == .connected }
            .sorted { $0.rssi > $1.rssi }
        
        otherDevices = Array(deviceMap.values)
            .filter { $0.peripheral.state != .connected }
            .sorted { $0.rssi > $1.rssi }
    }
    
    /// Wrapper for `update(device)`
    /// Discovers services and characteristics if needed
    func update(scan: ScanData) async throws {
        let peripheral = scan.peripheral
        
        if peripheral.state == .connected {
            print("Peripheral connected")
            if peripheral.discoveredServices?.first(where: { $0.uuid == Constants.serviceUUID }) == nil {
                try await peripheral.discoverServices([Constants.serviceUUID])
            }
            
            guard let service = peripheral.discoveredServices?
                .first(where: { $0.uuid == Constants.serviceUUID }) else {
                print("Service not found")
                return
            }
            
            if service.discoveredCharacteristics == nil || service.discoveredCharacteristics!.isEmpty {
                try await peripheral.discoverCharacteristics(
                    Constants.easySpotCharacteristics,
                    for: service
                )
            }
        } else {
            print("Peripheral not connected")
        }
        
        let characteristics = mapCharacteristics(peripheral)
        
        let device = Device(
            id: peripheral.identifier,
            name: peripheral.name,
            peripheral: peripheral,
            characteristics: characteristics,
            rssi: scan.rssi.intValue
        )
        
        update(device: device)
    }
    
    private func mapCharacteristics(_ peripheral: Peripheral) -> EasySpotCharacteristics {
        let service = peripheral.discoveredServices?
            .first(where: { $0.uuid == Constants.serviceUUID })
        
        var characteristics = EasySpotCharacteristics()
        
        guard let service else {
            // TODO: Handle error
            print("no service")
            return characteristics
        }
        
        guard let discoveredCharacteristics = service.discoveredCharacteristics else {
            // TODO: Handle error
            print("no chr")
            return characteristics
        }
        
        
        for characteristic in discoveredCharacteristics {
            if characteristic.uuid == Constants.CharacteristicUUIDs.status {
                characteristics.status = characteristic
            }
        }
        
        return characteristics
    }
}
