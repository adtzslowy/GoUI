//
//  MemoryReader.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import Foundation
import Darwin.Mach

enum MemoryReader {
    static func currentMemory() -> (usedGB: Double, totalGB: Double) {
        let totalGB = Double(ProcessInfo.processInfo.physicalMemory) / 1_073_741_824.0

        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(
            MemoryLayout<vm_statistics64_data_t>.stride / MemoryLayout<integer_t>.stride
        )

        let result: kern_return_t = withUnsafeMutablePointer(to: &stats) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPointer in
                host_statistics64(
                    mach_host_self(),
                    HOST_VM_INFO64,
                    intPointer,
                    &count
                )
            }
        }

        guard result == KERN_SUCCESS else {
            return (0, totalGB)
        }

        let pageSize = Double(vm_kernel_page_size)

        let appMemoryPages = Double(stats.internal_page_count)
        let wiredPages = Double(stats.wire_count)
        let compressedPages = Double(stats.compressor_page_count)

        let usedBytes = (appMemoryPages + wiredPages + compressedPages) * pageSize
        let usedGB = usedBytes / 1_073_741_824.0

        return (usedGB, totalGB)
    }
}

