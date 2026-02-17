//
//  TriggerView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 07/02/2026.
//

import SwiftUI

struct TriggerView: View {
    @ObservedObject var brain: BrainActivityModel
    @State private var activeTrigger: String? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let isiPhone = geometry.size.width < 500
            
            ZStack {
                Color(UIColor.secondarySystemGroupedBackground).ignoresSafeArea()
                
                Circle()
                    .fill(Color.blue.opacity(0.08))
                    .frame(width: isiPhone ? 400 : 600, height: isiPhone ? 400 : 600)
                    .blur(radius: isiPhone ? 60 : 100)
                    .offset(x: isiPhone ? -100 : -200, y: -300)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: isiPhone ? 20 : 30) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Biological Triggers")
                                .font(.system(size: isiPhone ? 28 : 34, weight: .black, design: .monospaced))
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, isiPhone ? 20 : 40)
                        .padding(.horizontal)
                        
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
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                TriggerCard(title: "Stress", icon: "bolt.fill", color: .orange, explanation: "Cortisol release increases neural excitability.", brain: brain, activeTrigger: $activeTrigger, isiPhone: isiPhone)
                                TriggerCard(title: "No Sleep", icon: "moon.zzz.fill", color: .purple, explanation: "Sleep deprivation impairs the brain's 'braking system.'", brain: brain, activeTrigger: $activeTrigger, isiPhone: isiPhone)
                            }
                            
                            HStack(spacing: 16) {
                                TriggerCard(title: "Hunger", icon: "fork.knife.circle", color: .yellow, explanation: "Low glucose levels starve neurons of stability.", brain: brain, activeTrigger: $activeTrigger, isiPhone: isiPhone)
                                TriggerCard(title: "Missed Meds", icon: "pills.fill", color: .red, explanation: "Anti-epileptic drugs act as a chemical dam.", brain: brain, activeTrigger: $activeTrigger, isiPhone: isiPhone)
                            }
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                brain.activityLevel = 0.2
                                activeTrigger = nil
                            }
                        }) {
                            Label("Restore Baseline", systemImage: "waveform.path")
                                .font(.system(isiPhone ? .subheadline : .headline, design: .rounded, weight: .bold))
                                .foregroundColor(.blue)
                                .padding(.vertical, isiPhone ? 12 : 16)
                                .frame(maxWidth: .infinity)
                                // Snug background fix
                                .background(.ultraThinMaterial, in: Capsule())
                                .background(Color.blue.opacity(0.1), in: Capsule())
                                .overlay(Capsule().stroke(.white, lineWidth: 2))
                        }
                        .padding(.horizontal, isiPhone ? 30 : 40)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("The Seizure Threshold")
                                .font(.system(isiPhone ? .headline : .title3, design: .rounded, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("Every brain exists in a delicate balance between excitatory and inhibitory signals. Your 'seizure threshold' is the biological limit that prevents these signals from becoming hypersynchronized. Think of this threshold as a dam: triggers like sleep deprivation or stress act as erosion, lowering the dam's height. When the threshold drops low enough, neurons begin to fire in a massive, unified surge—transforming rhythmic brainwaves into the high-voltage spikes of a seizure.")
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
    }
}

struct TriggerCard: View {
    let title: String
    let icon: String
    let color: Color
    let explanation: String
    @ObservedObject var brain: BrainActivityModel
    @Binding var activeTrigger: String?
    let isiPhone: Bool
    
    var isExpanded: Bool { activeTrigger == title }
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                if isExpanded {
                    activeTrigger = nil
                } else {
                    activeTrigger = title
                    brain.addStress(0.25)
                }
            }
        }) {
            VStack(alignment: .leading, spacing: isiPhone ? 8 : 12) {
                HStack {
                    Image(systemName: icon)
                        .font(isiPhone ? .headline.bold() : .title2.bold())
                        .foregroundColor(isExpanded ? color : .blue)
                    
                    Text(title)
                        .font(.system(isiPhone ? .subheadline : .headline, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                }
                
                if isExpanded {
                    Text(explanation)
                        .font(.system(.caption2, design: .rounded, weight: .bold))
                        .foregroundColor(.primary.opacity(0.7))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)), removal: .opacity))
                }
            }
            .padding(isiPhone ? 12 : 16)
            .frame(maxWidth: .infinity, minHeight: isiPhone ? 70 : 90, alignment: .topLeading)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
            .background(
                isExpanded ? color.opacity(0.18) : Color.white.opacity(0.4),
                in: RoundedRectangle(cornerRadius: 22)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isExpanded ? color.opacity(0.6) : .white.opacity(0.8), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
