import SwiftUI

struct BrightnessRow: View {
    @EnvironmentObject var service: ExternalBrightnessService
    let display: ExternalDisplay

    var value: Double {
        service.brightnessMap[display.id] ?? 100
    }

    var body: some View {
        VStack(spacing: 6) {

        
            HStack {
                Text(display.name)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))

                Spacer()

                Text("\(Int(value))%")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
            }

        
            ThinSliderStyle(
                value: Binding(
                    get: {
                        service.brightnessMap[display.id, default: 100]
                    },
                    set: { newValue in
                        service.brightnessMap[display.id] = newValue
                        service.setBrightness(Int(newValue), for: display.id)
                    }
                )
            )

            HStack {
                Image(systemName: "moon.fill")
                Spacer()
                Image(systemName: "sun.max.fill")
            }
            .foregroundColor(.white.opacity(0.5))
            .font(.system(size: 10))
        }
        .padding(10)
        .background(Color.white.opacity(0.03))
        .cornerRadius(10)
    }
}
