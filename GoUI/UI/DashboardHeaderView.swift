import SwiftUI

struct DashboardHeaderView: View {
    @EnvironmentObject var monitor: SystemMonitor

    var body: some View {
        HStack(spacing: 18) {
            statItem(
                title: "CPU",
                icon: "cpu",
                value: safe(cpuPercent / 100)
            )

            statItem(
                title: "MEM",
                icon: "memorychip",
                value: safe(memoryRatio)
            )

            statItem(
                title: "DISK",
                icon: "internaldrive",
                value: safe(diskRatio)
            )
        }
        .frame(maxWidth: .infinity)
    }
}

private extension DashboardHeaderView {
    func statItem(title: String, icon: String, value: Double) -> some View {
        RingStatView(
            title: title,
            systemImage: icon,
            value: value,
            percentageText: "\(Int(value * 100))%"
        )
    }
}


private extension DashboardHeaderView {

    var cpuPercent: Double {
        monitor.stats.cpuUsage
    }

    var memoryRatio: Double {
        let total = monitor.stats.memoryTotalGB
        guard total > 0 else { return 0 }
        return monitor.stats.memoryUsedGB / total
    }

    var diskRatio: Double {
        let total = monitor.stats.diskTotalGB
        guard total > 0 else { return 0 }
        return monitor.stats.diskUsedGB / total
    }

    func safe(_ value: Double) -> Double {
        min(max(value, 0), 1)
    }
}
