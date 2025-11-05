//
//  AppMenuDeviceList.swift
//  EasySpot
//
//  Created by Tymek on 05/11/2025.
//

import SwiftUI

struct AppMenuDeviceList: View {
    let title: String
    var devices: [Device] = []
    
    var body: some View {
        ScrollView() {
            Text(title)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(
                    devices,
                    id: \.id
                ) { device in
                    AppMenuDevice(
                        deviceName: device.name ?? "Unknown",
                        action: {}
                    )
                }
            }
            .padding(.top, 0)
        }
    }
}

#Preview {
    AppMenuDeviceList(title: "Your Devices")
}
