import SwiftUI

struct BrightnessCard: View {
    @EnvironmentObject var brightnessService: ExternalBrightnessService

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

        
            Text("External Monitor Brightness")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

            if brightnessService.isSupported {


                VStack(spacing: 6) {
                    HStack {
                        Text("All Displays")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))

                        Spacer()

                        Text("\(Int(brightnessService.brightness))%")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))
                    }

                    ThinSliderStyle(
                        value: Binding(
                            get: { brightnessService.brightness },
                            set: { newValue in
                                brightnessService.brightness = newValue
                                brightnessService.setBrightnessAll(Int(newValue))
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
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)

                
                ForEach(brightnessService.displays) { display in
                    BrightnessRow(display: display)
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
