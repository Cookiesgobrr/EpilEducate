//
//  BrainWaveView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 07/02/2026.
//

import SwiftUI


struct BrainWaveView: View {
    @ObservedObject var brain: BrainActivityModel
    

    var body: some View {

        TimelineView(.animation) { context in
            Canvas { ctx, size in
                let time = context.date.timeIntervalSinceReferenceDate
                let width = size.width
                let height = size.height
                let midHeight = height / 2
                

                let amplitude = 10 + (brain.activityLevel * 80)
                let frequency = 0.01 + (brain.activityLevel * 0.03)
                let speed = 4 + (brain.activityLevel * 15)
                
                var path = Path()
                path.move(to: CGPoint(x: 0, y: midHeight))
                
                for x in stride(from: 0, to: width, by: 2) {
                    let relativeX = x * frequency
                    let travel = time * speed
                    
                    let mainWave = sin(relativeX + travel)
                    let jaggedness = sin(relativeX * 3 + travel) * (brain.activityLevel * 0.5)
                    
                    let y = midHeight + (mainWave + jaggedness) * amplitude
                    
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
              let waveColor = Color(
                    red: brain.activityLevel,
                    green: 0.2,
                    blue: 1.0 - brain.activityLevel
                )
                
                ctx.stroke(path, with: .color(waveColor), lineWidth: 3)

            }

        }

        .background(Color.black.opacity(0.9))

        .cornerRadius(15)

    }

}
