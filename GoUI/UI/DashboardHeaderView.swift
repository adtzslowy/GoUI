//
//  DashboardHeaderView.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import SwiftUI

struct DashboardHeaderView: View {
    @EnvironmentObject var monitor: SystemMonitor

    var body: some View {
        HStack(spacing: 18) {
            RingStatView(
                title: "CPU",
                systemImage: "cpu",
                value: monitor.stats.cpuUsage / 100.0,
                percentageText: "\(Int(monitor.stats.cpuUsage))%"
            )

            RingStatView(
                title: "MEM",
                systemImage: "memorychip",
                value: monitor.stats.memoryTotalGB > 0
                    ? monitor.stats.memoryUsedGB / monitor.stats.memoryTotalGB
                    : 0,
                percentageText: "\(Int(memoryPercent))%"
            )

            RingStatView(
                title: "DISK",
                systemImage: "internaldrive",
                value: monitor.stats.diskTotalGB > 0
                    ? monitor.stats.diskUsedGB / monitor.stats.diskTotalGB
                    : 0,
                percentageText: "\(Int(diskPercent))%"
            )
        }
        .frame(maxWidth: .infinity)
    }

    private var memoryPercent: Double {
        guard monitor.stats.memoryTotalGB > 0 else { return 0 }
        return (monitor.stats.memoryUsedGB / monitor.stats.memoryTotalGB) * 100
    }

    private var diskPercent: Double {
        guard monitor.stats.diskTotalGB > 0 else { return 0 }
        return (monitor.stats.diskUsedGB / monitor.stats.diskTotalGB) * 100
    }
}
