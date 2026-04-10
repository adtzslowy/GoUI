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
    
    private var ringColor: Color {
        switch value {
        case 0..<0.6:
            return .green
        case 0.6..<0.8:
            return .orange
        default:
            return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().stroke(Color.white.opacity(0.12), lineWidth: 9)
                
                Circle().trim(from: 0, to: max(0.02, min(value, 1.0))).stroke(ringColor, style: StrokeStyle(lineWidth: 9, lineCap: .round)).rotationEffect(.degrees(-90))
                
                VStack(spacing: 6) {
                    Image(systemName: systemImage).font(.system(size: 17, weight: .semibold)).foregroundColor(.white)
                    
                    Text(percentageText).font(.system(size: 11, weight: .bold)).foregroundColor(.white.opacity(0.95))
                }
            }
            .frame(width: 78, height: 78)
            
            Text(title).font(.system(size: 11, weight: .semibold)).foregroundColor(.white.opacity(0.85))
            
        }
    }
}
