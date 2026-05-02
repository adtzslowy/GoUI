//
//  SystemMonitor.swift
//  GoUI
//

import Foundation
import Combine

final class SystemMonitor: ObservableObject {
    @Published var stats = SystemStats()

    private var timer: Timer?

    init() {
        refresh()

        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.refresh()
        }
    }

    deinit {
        timer?.invalidate()
    }

    func refresh() {
        stats.cpuUsage    = CPUReader.currentCPUUsage()

        let memory        = MemoryReader.currentMemory()
        stats.memoryUsedGB  = memory.usedGB
        stats.memoryTotalGB = memory.totalGB

        let disk          = DiskReader.currentDiskUsage()
        stats.diskUsedGB  = disk.usedGB
        stats.diskTotalGB = disk.totalGB

        stats.fans = FanMonitor.currentFans()
    }
}
