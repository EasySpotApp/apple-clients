#if os(macOS)
import AppKit
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    var bluetoothManager: BluetoothManager = BluetoothManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(named: "TrayIconDisabled")
            button.image?.isTemplate = true
            button.action = #selector(showMenu(_:))
            button.target = self
        }
    }
    
    @objc func showMenu(_ sender: AnyObject?) {
        guard let button = statusBarItem?.button else { return }
        
        let menu = NSMenu()
        
        menu
            .addItem(
                swiftUItoNSItem(
                    AppMenuContent().environmentObject(bluetoothManager)
                )
            )
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        // TODO: Check if the offsets look good on notchless macs
        menu.popUp(positioning: nil, at: NSPoint(x: -2, y: button.bounds.height + 5), in: button)
    }
    
    func swiftUItoNSItem(_ view: some View) -> NSMenuItem {
        let menuItem = NSMenuItem()
        let hostingView = NSHostingView(rootView: view)
        
//        let targetSize = hostingView.fittingSize
        hostingView.frame = NSRect(
            x: 0,
            y: 0,
            width: 300,
            height: 300
        )
        menuItem.view = hostingView
        
        return menuItem
    }
    
}
#endif
