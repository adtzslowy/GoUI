//
//  FanHelper.swift
//  GoUIHelper
//

import Foundation

class FanHelper: NSObject, HelperProtocol {

    func getVersion(reply: @escaping (String) -> Void) {
        reply("1.0.0")
    }

    func setFanMinSpeed(_ rpm: Int, reply: @escaping (Bool, String) -> Void) {
        do {
            try SMCKit.open()
            defer { _ = SMCKit.close() }

            let fans = try SMCKit.allFans()
            guard !fans.isEmpty else {
                reply(false, "Tidak ada fan terdeteksi")
                return
            }

            for fan in fans {
                try SMCKit.fanSetMinSpeed(fan.id, speed: rpm)
            }

            reply(true, "Fan speed diatur ke \(rpm) RPM")

        } catch let err as SMCKit.SMCError {
            switch err {
            case .unsafeFanSpeed:
                reply(false, "RPM tidak valid — melebihi batas hardware")
            case .notPrivileged:
                reply(false, "Butuh akses root")
            default:
                reply(false, "SMC Error: \(err)")
            }
        } catch {
            reply(false, "Error: \(error.localizedDescription)")
        }
    }

    func resetFanAuto(reply: @escaping (Bool, String) -> Void) {
        do {
            try SMCKit.open()
            defer { _ = SMCKit.close() }

            let fans = try SMCKit.allFans()
            guard !fans.isEmpty else {
                reply(false, "Tidak ada fan terdeteksi")
                return
            }

            for fan in fans {
                try SMCKit.fanSetMinSpeed(fan.id, speed: fan.minSpeed)
            }

            reply(true, "Fan kembali ke mode auto")

        } catch {
            reply(false, "Error: \(error.localizedDescription)")
        }
    }
    
    func getFanInfo(reply: @escaping ([[String: Any]]) -> Void) {
        do {
            try SMCKit.open()
            defer { _ = SMCKit.close() }

            let fans = try SMCKit.allFans()
            var result: [[String: Any]] = []

            for fan in fans {
                let rpm = (try? SMCKit.fanCurrentSpeed(fan.id)) ?? 0
                result.append([
                    "id"      : fan.id,
                    "name"    : fan.name,
                    "minSpeed": fan.minSpeed,
                    "maxSpeed": fan.maxSpeed,
                    "rpm"     : rpm
                ])
            }

            reply(result)
        } catch {
            reply([])
        }
    }
}
