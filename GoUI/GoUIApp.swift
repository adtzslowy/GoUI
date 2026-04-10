//
//  GoUIApp.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import SwiftUI

@main
struct GoUIApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
