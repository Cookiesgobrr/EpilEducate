//
//  TestView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 07/02/2026.
//

import SwiftUI

struct TestView: View {
    @StateObject var brain = BrainActivityModel()
    
    var body: some View {
        GeometryReader { geometry in
            let isiPhone = geometry.size.width < 500
            
            VStack(spacing: isiPhone ? 20 : 30) {
                Spacer()
                
                Text("Brain Activity: \(Int(brain.activityLevel * 100))%")
                    .font(isiPhone ? .title2 : .title)
                    .bold()
                    .foregroundColor(.white)
                
                BrainWaveView(brain: brain)
                    .frame(height: isiPhone ? 220 : 300)
                    .padding()
                
                HStack(spacing: isiPhone ? 60 : 80) {
                    Button(action: {
                        brain.calmDown(0.2)
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "heart.circle.fill")
                                .font(isiPhone ? .title : .largeTitle)
                            Text("Calm")
                                .font(.system(.headline, design: .rounded))
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        brain.addStress(0.2)
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "bolt.circle.fill")
                                .font(isiPhone ? .title : .largeTitle)
                            Text("Trigger")
                                .font(.system(.headline, design: .rounded))
                        }
                        .foregroundColor(.red)
                    }
                }
                .padding(.bottom, isiPhone ? 40 : 20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
        }
    }
}
