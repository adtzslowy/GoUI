import SwiftUI

struct ThinSliderStyle: View {
    @Binding var value: Double // 0...100

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let normalized = min(max(value / 100, 0), 1)
            let xPos = normalized * width

            ZStack(alignment: .leading) {

                
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 10)

                
                Capsule()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: xPos, height: 10)

                
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                    .shadow(color: .black.opacity(0.2), radius: 2)
                    .offset(x: xPos - 10) // 🔥 FIX center
                    .animation(.easeOut(duration: 0.12), value: value)
            }
             
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let newX = min(max(0, gesture.location.x), width)
                        let newValue = (newX / width) * 100
                        value = newValue
                    }
            )
        }
        .frame(height: 20)
    }
}
