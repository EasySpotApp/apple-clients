//
//  AppMenuContent.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//
#if os(macOS)

import SwiftUI

struct AppMenuContent: View {
    @State private var showGreeting = true
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            AppMenuHeader()
            
            ScrollView() {
                AppMenuDeviceList(
                    title: "Your Devices",
                    devices: bluetoothManager.deviceStore.pairedDevices
                )
                AppMenuDeviceList(
                    title: "Other Devices",
                    devices: bluetoothManager.deviceStore.otherDevices
                )
            }
        }
        .frame(maxWidth: 300, alignment: .leading)
    }
}

#Preview {
    AppMenuContent()
}

#endif
