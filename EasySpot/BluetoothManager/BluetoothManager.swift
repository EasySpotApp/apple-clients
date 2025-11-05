import Combine
import AsyncBluetooth
import CoreBluetooth
import SwiftUI

class BluetoothManager: ObservableObject {
    @Published var status: ManagerStatus = .waiting
    @Published var deviceErrors: [DeviceErrorInfo] = []
    @Published var deviceStore = DeviceStore()

    private var central = CentralManager()
    private var scanTask: Task<Void, Never>?

    init() {
        print("init")
        startScanning()
    }
    
    func startScanning() {
        scanTask?.cancel()
        scanTask = Task {
            do {
                status = .waiting
                print("waiting for bluetooth")
                
                try await central.waitUntilReady()
                
                await MainActor.run {
                    status = .scanning
                }
                print("bluetooth ready")
                
                let stream = try await central
                    .scanForPeripherals(withServices: [Constants.serviceUUID])
                for await scan in stream {
                    print("Serivce found: \(scan.peripheral.name ?? "Unknown")")
                    try await deviceStore.update(scan: scan)
                }
            } catch {
                // TODO: Handle the error
            }
        }
    }
}
