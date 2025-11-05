//
//  Device.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

import Foundation
import CoreBluetooth
import AsyncBluetooth

struct Device: Identifiable, Equatable {
    let id: UUID
    let name: String?
    let peripheral: Peripheral
    var characteristics: EasySpotCharacteristics
    var rssi: Int
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        lhs.id == rhs.id
    }
}

struct EasySpotCharacteristics {
    var status: Characteristic? = .none
}

