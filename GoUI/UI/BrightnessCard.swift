//
//  BrightnessCard.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import SwiftUI

struct BrightnessCard: View {
    @EnvironmentObject var brightnessService: ExternalBrightnessService

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("External Monitor Brightness")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

            if brightnessService.isSupported {
                Slider(value: $brightnessService.brightness, in: 0...100, step: 1)
                    .onChange(of: brightnessService.brightness) { newValue in
                        brightnessService.setBrightness(Int(newValue))
                    }

                HStack {
                    Image(systemName: "moon.fill")
                        .foregroundColor(.white.opacity(0.6))

                    Spacer()

                    Text("\(Int(brightnessService.brightness))%")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))

                    Spacer()

                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.white.opacity(0.6))
                }
            } else {
                Text(brightnessService.statusMessage)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.65))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
        )
    }
}
