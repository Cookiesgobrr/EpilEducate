//
//  RecoveryView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 07/02/2026.
//

import SwiftUI

struct RecoveryView: View {
    @ObservedObject var brain: BrainActivityModel
    @State private var hasSpiked = false
    
    var body: some View {
        GeometryReader { geometry in
            let isiPhone = geometry.size.width < 500
            
            ZStack {
                // background layers for a clean, medical look
                Color(UIColor.secondarySystemGroupedBackground).ignoresSafeArea()
                
                Circle()
                    .fill(Color.green.opacity(0.08))
                    .frame(width: isiPhone ? 400 : 600, height: isiPhone ? 400 : 600)
                    .blur(radius: isiPhone ? 60 : 100)
                    .offset(x: isiPhone ? 100 : 200, y: -300)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: isiPhone ? 20 : 30) {
                        // page header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Restoring Balance")
                                .font(.system(size: isiPhone ? 28 : 34, weight: .black, design: .monospaced))
                                .foregroundColor(.green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, isiPhone ? 20 : 40)
                        .padding(.horizontal)
                        
                        // main eeg monitor card
                        VStack {
                            NeuralView(brain: brain)
                                .frame(height: isiPhone ? 180 : 250)
                                .padding(isiPhone ? 8 : 12)
                                .background(Color.black.opacity(0.9), in: RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(10)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 32))
                        .overlay(RoundedRectangle(cornerRadius: 32).stroke(.white, lineWidth: 2))
                        .padding(.horizontal)
                        
                        Text("Consistency helps bring activity back into balance.")
                            .font(.system(isiPhone ? .subheadline : .body, design: .rounded, weight: .bold))
                            .foregroundColor(.primary.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        // grid of buttons that lower the brain activity level
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                FactorButton(title: "Medication", icon: "pills.fill", color: .green, isiPhone: isiPhone) {
                                    brain.calmDown(0.35)
                                }
                                FactorButton(title: "Rest", icon: "bed.double.fill", color: .blue, isiPhone: isiPhone) {
                                    brain.calmDown(0.25)
                                }
                            }
                            HStack(spacing: 16) {
                                FactorButton(title: "Routine", icon: "calendar", color: .teal, isiPhone: isiPhone) {
                                    brain.calmDown(0.20)
                                }
                                FactorButton(title: "Mindfulness", icon: "leaf.fill", color: .mint, isiPhone: isiPhone) {
                                    brain.calmDown(0.15)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // educational info section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Stable Foundations")
                                .font(.system(isiPhone ? .headline : .title3, design: .rounded, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("Managing epilepsy is about raising that 'seizure threshold.' Regular sleep and medication create a chemical buffer that prevents the brain's electrical signals from surging out of control.")
                                .font(.system(isiPhone ? .footnote : .body, design: .rounded, weight: .semibold))
                                .foregroundColor(.primary.opacity(0.8))
                                .lineSpacing(isiPhone ? 2 : 4)
                        }
                        .padding(isiPhone ? 18 : 24)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25))
                        .background(Color.white.opacity(0.4), in: RoundedRectangle(cornerRadius: 25))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(.white, lineWidth: 2))
                        .padding(.horizontal)
                        
                        Spacer(minLength: 80)
                    }
                }
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            if brain.activityLevel <= 0.3 && !hasSpiked {
                withAnimation(.easeInOut(duration: 1.5)) {
                    brain.activityLevel = 0.8
                }
                hasSpiked = true
            }
        }
    }
}

// custom button style for the recovery factors
struct FactorButton: View {
    let title: String
    let icon: String
    let color: Color
    let isiPhone: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
            withAnimation(.spring()) { action() }
        }) {
            VStack(spacing: isiPhone ? 8 : 12) {
                Image(systemName: icon)
                    .font(isiPhone ? .headline.bold() : .title2.bold())
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(isiPhone ? .caption : .headline, design: .rounded, weight: .bold))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, isiPhone ? 14 : 20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
            .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 22))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(.white, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.04), radius: 10, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
