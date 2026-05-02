//
//  RingStatView.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import SwiftUI

struct RingStatView: View {
    let title: String
    let systemImage: String
    let value: Double
    let percentageText: String
    
    private var clampedValue: Double {
        min(max(value, 0.02), 1.0)
    }
    
    private var ringColor: Color {
        Color(hue: (1.0 - value) * 0.33, saturation: 0.9, brightness: 0.9)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.12), lineWidth: 9)
                
                Circle()
                    .trim(from: 0, to: clampedValue)
                    .stroke(ringColor, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.35), value: value)
                
                VStack(spacing: 6) {
                    Image(systemName: systemImage)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(percentageText)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.95))
                }
            }
            .frame(width: 78, height: 78)
            
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))
        }
    }
}
