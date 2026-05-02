import SwiftUI

struct DashboardHeaderView: View {
    @EnvironmentObject var monitor: SystemMonitor

    var body: some View {
        HStack(spacing: 18) {
            RingStatView(
                title: "CPU",
                systemImage: "cpu",
                value: cpuValue,
                percentageText: percentText(cpuPercent)
            )

            RingStatView(
                title: "MEM",
                systemImage: "memorychip",
                value: memoryValue,
                percentageText: percentText(memoryPercent)
            )

            RingStatView(
                title: "DISK",
                systemImage: "internaldrive",
                value: diskValue,
                percentageText: percentText(diskPercent)
            )
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Values (0...1)

    private var cpuValue: Double {
        monitor.stats.cpuUsage / 100.0
    }

    private var memoryValue: Double {
        guard monitor.stats.memoryTotalGB > 0 else { return 0 }
        return monitor.stats.memoryUsedGB / monitor.stats.memoryTotalGB
    }

    private var diskValue: Double {
        guard monitor.stats.diskTotalGB > 0 else { return 0 }
        return monitor.stats.diskUsedGB / monitor.stats.diskTotalGB
    }

    // MARK: - Percent (0...100)

    private var cpuPercent: Double {
        monitor.stats.cpuUsage
    }

    private var memoryPercent: Double {
        memoryValue * 100
    }

    private var diskPercent: Double {
        diskValue * 100
    }

    private func percentText(_ value: Double) -> String {
        "\(Int(value))%"
    }
}
