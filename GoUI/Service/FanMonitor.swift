import Foundation

enum FanMonitor {
    static func currentFans() -> [FanInfo] {
        do {
            print("Trying SMCKit.open()...")
            try SMCKit.open()
            defer { _ = SMCKit.close() }

            let count = try SMCKit.fanCount()
            print("Fan count =", count)

            guard count > 0 else { return [] }

            var fans: [FanInfo] = []

            for index in 0..<count {
                let rpm = try SMCKit.fanCurrentSpeed(index)
                let minRPM = try SMCKit.fanMinSpeed(index)
                let maxRPM = try SMCKit.fanMaxSpeed(index)

                let rawName = (try? SMCKit.fanName(index)) ?? ""
                let cleanName = rawName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? (count == 1 ? "System Fan" : "Fan \(index + 1)")
                    : rawName

                fans.append(FanInfo(id: index, name: cleanName, rpm: rpm, maxRPM: maxRPM, minRPM: minRPM))
            }

            return fans
        } catch {
            print("SMCKit error:", error)
            return []
        }
    }
}

