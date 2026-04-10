//
//  DiskReader.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import Foundation

enum DiskReader {
    static func currentDiskUsage() -> (usedGB: Double, totalGB: Double) {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let total = (attrs[.systemSize] as? NSNumber)?.doubleValue ?? 0
            let free = (attrs[.systemFreeSize] as? NSNumber)?.doubleValue ?? 0
            let used = total - free;
            
            return (used / 1_073_741_824, total / 1_073_741_824)
        } catch {
            return (0, 0)
        }
    }
}
