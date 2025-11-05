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
    
    @ObservedObject var manager = BluetoothManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            AppMenuHeader()
                
            Text("Your Devices")
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                
            ScrollView() {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(
                        manager.deviceStore.pairedDevices,
                        id: \.id
                    ) { device in
                        AppMenuDevice(
                            deviceName: device.name ?? "Unknown",
                            action: {}
                        )
                    }
                }
                Divider()
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(manager.deviceStore.otherDevices, id: \.id) { device in
                        AppMenuDevice(
                            deviceName: device.name ?? "Unknown",
                            action: {}
                        )
                    }
                }
            }
        }
        .frame(maxWidth: 300, alignment: .leading)
    }
}

#Preview {
    AppMenuContent()
}

#endif
