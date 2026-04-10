//
//  SystemStats.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import Foundation

struct FanInfo: Identifiable, Hashable {
    let id: Int
    let name: String
    let rpm: Int
    let maxRPM: Int
    let minRPM: Int
}

struct SystemStats {
    var cpuUsage: Double = 0
    var memoryUsedGB: Double = 0
    var memoryTotalGB: Double = 0
    var diskUsedGB: Double = 0
    var diskTotalGB: Double = 0
    var fans: [FanInfo] = []
}
