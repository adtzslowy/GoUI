//
//  FanControlCard.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import SwiftUI

struct FanControlCard: View {
    @EnvironmentObject var monitor: SystemMonitor

    @State private var isManualMode = false
    @State private var manualFanRPM: Double = 2500
    @State private var statusText: String = "System-controlled fan mode"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fan Control")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

            HStack(spacing: 10) {
                modeButton(title: "Auto", active: !isManualMode) {
                    isManualMode = false
                    do {
                        try SMCKit.open()
                        defer { _ = SMCKit.close() }
                        for fan in monitor.stats.fans {
                            try SMCKit.fanSetMinSpeed(fan.id, speed: fan.minRPM)
                        }
                        statusText = "Fan kembali ke auto"
                    } catch SMCKit.SMCError.notPrivileged {
                        statusText = "Butuh akses root"
                    } catch {
                        statusText = "Error: \(error.localizedDescription)"
                    }
                }

                modeButton(title: "Manual", active: isManualMode) {
                    isManualMode = true
                    if let firstFan = monitor.stats.fans.first {
                        manualFanRPM = Double(firstFan.minRPM)
                    }
                    statusText = "Pilih RPM lalu Apply"
                }
            }

            if monitor.stats.fans.isEmpty {
                Text("Fan sensor belum tersedia.")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.65))
            } else {
                ForEach(monitor.stats.fans) { fan in
                    infoRow(
                        title: fan.name,
                        value: "\(fan.rpm) RPM  •  min \(fan.minRPM) / max \(fan.maxRPM)"
                    )
                }
            }

            if isManualMode, let sliderRange = sliderRange {
                VStack(alignment: .leading, spacing: 10) {
                    Slider(value: $manualFanRPM, in: sliderRange, step: 100)

                    HStack {
                        Text("Manual Speed")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.65))

                        Spacer()

                        Text("\(Int(manualFanRPM)) RPM")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Button("Apply") {
                        do {
                            try SMCKit.open()
                            defer { _ = SMCKit.close() }
                            for fan in monitor.stats.fans {
                                try SMCKit.fanSetMinSpeed(fan.id, speed: Int(manualFanRPM))
                            }
                            statusText = "Fan diatur ke \(Int(manualFanRPM)) RPM"
                        } catch SMCKit.SMCError.notPrivileged {
                            statusText = "Butuh akses root"
                        } catch SMCKit.SMCError.unsafeFanSpeed {
                            statusText = "RPM tidak valid"
                        } catch {
                            statusText = "Error: \(error.localizedDescription)"
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.blue.opacity(0.95))
                    )
                    .foregroundColor(.white)
                }
                .padding(.top, 2)
            }

            Text(statusText)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.62))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.07))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    private var sliderRange: ClosedRange<Double>? {
        guard !monitor.stats.fans.isEmpty else { return nil }
        let minValue = monitor.stats.fans.map(\.minRPM).min() ?? 1299
        let maxValue = monitor.stats.fans.map(\.maxRPM).max() ?? 6199
        guard minValue < maxValue else { return nil }
        return Double(minValue)...Double(maxValue)
    }

    private func modeButton(title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(active ? Color.blue.opacity(0.95) : Color.white.opacity(0.08))
                )
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.66))
        }
    }
}
