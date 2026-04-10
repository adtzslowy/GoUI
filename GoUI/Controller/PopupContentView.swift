//
//  PopupContentView.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import SwiftUI

struct PopupContentView: View {
    @EnvironmentObject var monitor: SystemMonitor
    @EnvironmentObject var brightnessService: ExternalBrightnessService

    var body: some View {
        VStack(spacing: 16) {
            DashboardHeaderView()
                .environmentObject(monitor)

            FanControlCard()
                .environmentObject(monitor)

            BrightnessCard()
                .environmentObject(brightnessService)

            footer
        }
        .padding(16)
        .frame(width: 360)
        .background(
            ZStack {
                Color.black.opacity(0.1)

                LinearGradient(
                    colors: [
                        Color.white.opacity(0.10),
                        Color.white.opacity(0.03)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
    }

    private var footer: some View {
        HStack {
            Button("Preferences") {
            }
            .buttonStyle(.plain)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white.opacity(0.72))

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
        .padding(.top, 2)
    }
}

