//
//  FanMonitor.swift
//  GoUI
//

import Foundation

enum FanMonitor {
    static func currentFans() -> [FanInfo] {
        do {
            try SMCKit.open()
            defer { _ = SMCKit.close() }

            let fans = try SMCKit.allFans()
            guard !fans.isEmpty else { return [] }

            return fans.map { fan in
                let rpm = (try? SMCKit.fanCurrentSpeed(fan.id)) ?? 0
                let name = fan.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? (fans.count == 1 ? "System Fan" : "Fan \(fan.id + 1)")
                    : fan.name
                return FanInfo(id: fan.id, name: name, rpm: rpm,
                               maxRPM: fan.maxSpeed, minRPM: fan.minSpeed)
            }
        } catch {
            print("SMCKit error:", error)
            return []
        }
    }
}
