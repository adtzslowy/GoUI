//
//  StatusBarController.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import Cocoa
import SwiftUI

final class StatusBarController: NSObject {
    private let statusItem: NSStatusItem
    private let popover: NSPopover
    
    private let monitor = SystemMonitor()
    private let brightnessService = ExternalBrightnessService()
    
    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        popover = NSPopover()
        
        super.init()
        
        if let button = statusItem.button {
            let image = NSImage(systemSymbolName: "gauge.medium", accessibilityDescription: "GoUI")
            image?.isTemplate = true
            button.image = NSImage(systemSymbolName: "cpu", accessibilityDescription: "GoUI")
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        let contentView = PopupContentView().environmentObject(monitor).environmentObject(brightnessService)

        popover.contentSize = NSSize(width: 360, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.contentViewController?.view.wantsLayer = true
        popover.contentViewController?.view.layer?.cornerRadius = 20
        popover.contentViewController?.view.layer?.masksToBounds = true
    }

    @objc private func togglePopover(_ sender: AnyObject?) {
        guard let button = statusItem.button else {return}

        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
}
