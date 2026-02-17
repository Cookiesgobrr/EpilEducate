//
//  WelcomeView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 20/01/2026.
//

import SwiftUI

struct WelcomeView: View {
    // Local brain model just for the background animation on this screen
    @StateObject var calmBrain = BrainActivityModel()
    
    var body: some View {
        GeometryReader { geometry in
            let isiPhone = geometry.size.width < 500
            
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                BrainWaveView(brain: calmBrain)
                    .ignoresSafeArea()
                    .opacity(0.12)
                    .foregroundColor(.blue)
                
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: isiPhone ? 400 : 600, height: isiPhone ? 400 : 600)
                    .blur(radius: isiPhone ? 80 : 120)
                    .offset(x: isiPhone ? -100 : -150, y: -250)

                VStack(spacing: isiPhone ? 15 : 25) {
                    Spacer()
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: isiPhone ? 60 : 80))
                        .foregroundColor(.blue)
                        .padding(isiPhone ? 20 : 30)
                        .background(.ultraThinMaterial, in: Circle())
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.06), radius: 20, y: 10)
                    
                    VStack(spacing: isiPhone ? 8 : 12) {
                        Text("EpilEducate")
                            .font(.system(size: isiPhone ? 42 : 54, weight: .black, design: .monospaced))
                            .foregroundColor(.primary)
                            .minimumScaleFactor(0.8) // Extra safety for small screens
                        
                        Text("Made with ❤️ by Tarun Abraham")
                            .font(.system(isiPhone ? .headline : .title2, design: .rounded, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(1.2)
                        
                        Text("This playground was designed for the 2026 WWDC Swift Student Challenge, and does not count as medical advice. Always seek help from a medical professional, preferably a neurologist, if you require medical assistance.")
                            .font(.system(isiPhone ? .caption : .subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, isiPhone ? 30 : 40)
                            .lineSpacing(isiPhone ? 2 : 4)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Swipe to begin")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blue.opacity(0.5))
                    }
                    .padding(.bottom, isiPhone ? 30 : 50)
                }
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            calmBrain.activityLevel = 0.15
        }
    }
}
