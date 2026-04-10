//
//  CPUReader.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import Foundation
import Darwin.Mach

enum CPUReader {
    private static var previousInfo: processor_info_array_t?
    private static var previousInfoCount: mach_msg_type_number_t = 0

    static func currentCPUUsage() -> Double {
        var numCPUsU: natural_t = 0
        var cpuInfo: processor_info_array_t?
        var numCPUInfo: mach_msg_type_number_t = 0

        let result = host_processor_info(
            mach_host_self(),
            PROCESSOR_CPU_LOAD_INFO,
            &numCPUsU,
            &cpuInfo,
            &numCPUInfo
        )

        guard result == KERN_SUCCESS, let cpuInfo = cpuInfo else {
            return 0
        }

        var totalUsage: Double = 0

        for cpu in 0..<Int(numCPUsU) {
            let index = Int(CPU_STATE_MAX) * cpu

            let user = Double(cpuInfo[index + Int(CPU_STATE_USER)])
            let system = Double(cpuInfo[index + Int(CPU_STATE_SYSTEM)])
            let idle = Double(cpuInfo[index + Int(CPU_STATE_IDLE)])
            let nice = Double(cpuInfo[index + Int(CPU_STATE_NICE)])

            var prevUser = 0.0
            var prevSystem = 0.0
            var prevIdle = 0.0
            var prevNice = 0.0

            if let prev = previousInfo {
                prevUser = Double(prev[index + Int(CPU_STATE_USER)])
                prevSystem = Double(prev[index + Int(CPU_STATE_SYSTEM)])
                prevIdle = Double(prev[index + Int(CPU_STATE_IDLE)])
                prevNice = Double(prev[index + Int(CPU_STATE_NICE)])
            }

            let userDiff = user - prevUser
            let systemDiff = system - prevSystem
            let idleDiff = idle - prevIdle
            let niceDiff = nice - prevNice

            let inUse = userDiff + systemDiff + niceDiff
            let total = inUse + idleDiff

            if total > 0 {
                totalUsage += inUse / total
            }
        }

        if let prev = previousInfo {
            let prevSize = vm_size_t(previousInfoCount) * vm_size_t(MemoryLayout<integer_t>.size)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: prev), prevSize)
        }

        previousInfo = cpuInfo
        previousInfoCount = numCPUInfo

        guard numCPUsU > 0 else { return 0 }
        return (totalUsage / Double(numCPUsU)) * 100
    }
}

