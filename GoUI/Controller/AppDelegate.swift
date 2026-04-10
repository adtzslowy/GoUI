//
//  AppDelegate.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusBarController = StatusBarController()
    }
}

