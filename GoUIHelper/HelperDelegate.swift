//
//  HelperDelegate.swift
//  GoUIHelper
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import Foundation

final class HelperDelegate: NSObject, NSXPCListenerDelegate, GoUIHelperProtocol {
    private let listener: NSXPCListener

    override init() {
        self.listener = NSXPCListener.service()
        super.init()
        self.listener.delegate = self
    }

    func run() {
        listener.resume()
        RunLoop.current.run()
    }

    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: GoUIHelperProtocol.self)
        newConnection.exportedObject = self
        newConnection.resume()
        return true
    }

    func setFanMinSpeed(_ rpm: NSNumber, withReply reply: @escaping (NSNumber, NSString) -> Void) {
        do {
            try SMCKit.open()
            defer { _ = SMCKit.close() }

            let count = try SMCKit.fanCount()
            guard count > 0 else {
                reply(false, "No fan found")
                return
            }

            let requested = rpm.intValue

            for index in 0..<count {
                let maxRPM = try SMCKit.fanMaxSpeed(index)
                let minRPM = try SMCKit.fanMinSpeed(index)
                let safeRPM = max(minRPM, min(requested, maxRPM))
                try SMCKit.fanSetMinSpeed(index, speed: safeRPM)
            }

            reply(true, "Fan minimum speed updated")
        } catch {
            reply(false, "\(error)" as NSString)
        }
    }

    func resetFanAuto(_ reply: @escaping (NSNumber, NSString) -> Void) {
        do {
            try SMCKit.open()
            defer { _ = SMCKit.close() }

            let count = try SMCKit.fanCount()
            guard count > 0 else {
                reply(false, "No fan found")
                return
            }

            for index in 0..<count {
                let defaultMin = try SMCKit.fanMinSpeed(index)
                try SMCKit.fanSetMinSpeed(index, speed: defaultMin)
            }

            reply(true, "Fan reset requested")
        } catch {
            reply(false, "\(error)" as NSString)
        }
    }
}
