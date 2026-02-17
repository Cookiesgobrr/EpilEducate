import SwiftUI

struct ExploreView: View {
    @ObservedObject var brain: BrainActivityModel
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            let isiPhone = geometry.size.width < 500
            
            ZStack {
                // Layer 1: Pure White Background Base
                Color.white.ignoresSafeArea()
                
                // Layer 2: Dynamic Ambient Glow
                Circle()
                    .fill(brain.activityLevel > 0.7 ? Color.red.opacity(0.12) : Color.blue.opacity(0.1))
                    .frame(width: isiPhone ? 400 : 600, height: isiPhone ? 400 : 600)
                    .blur(radius: isiPhone ? 60 : 100)
                    .offset(x: -50, y: -150)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: isiPhone ? 25 : 30) {
                        Text("Explore Mode")
                            .font(.system(size: isiPhone ? 28 : 34, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                            .padding(.top, isiPhone ? 20 : 40)
                        
                        // Alert Section
                        ZStack {
                            if brain.activityLevel > 0.85 {
                                Text("⚠️ SEIZURE IMMINENT")
                                    .font(.system(size: isiPhone ? 14 : 18, weight: .black, design: .monospaced))
                                    .foregroundColor(.red)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.red, lineWidth: 3)
                                            .shadow(color: .red, radius: pulseScale * 8)
                                    )
                                    .scaleEffect(pulseScale)
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 0.2).repeatForever(autoreverses: true)) {
                                            pulseScale = 1.1
                                        }
                                    }
                            }
                        }
                        .frame(height: 50)

                        // --- LIQUID GLASS NEURAL MONITOR ---
                        VStack {
                            NeuralView(brain: brain)
                                .frame(height: isiPhone ? 200 : 240)
                                .padding(isiPhone ? 8 : 15)
                                .background(Color.black.opacity(0.92), in: RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(12)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 32).fill(Color.white.opacity(0.4))
                                RoundedRectangle(cornerRadius: 32).fill(.ultraThinMaterial)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(
                                    LinearGradient(colors: [.white, .white.opacity(0.4), .clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 10)
                        .padding(.horizontal)

                        // Activity Level Bar
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Brain Activity Level")
                                .font(.system(.caption, design: .rounded, weight: .bold))
                                .foregroundColor(.gray)
                            
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1))
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(LinearGradient(colors: [.blue, .purple, .red], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: geo.size.width * brain.activityLevel)
                                }
                            }
                            .frame(height: 12)
                        }
                        .padding(.horizontal, isiPhone ? 25 : 35)

                        // Interaction Grid
                        VStack(spacing: isiPhone ? 20 : 30) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Add Triggers")
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundColor(.orange)
                                
                                let layout = isiPhone ? AnyLayout(VStackLayout(spacing: 12)) : AnyLayout(HStackLayout(spacing: 12))
                                
                                layout {
                                    ExploreButton(title: "Stress", color: .orange) { brain.addStress(0.15) }
                                    ExploreButton(title: "No Sleep", color: .purple) { brain.addStress(0.2) }
                                    ExploreButton(title: "Hunger", color: .yellow) { brain.addStress(0.15) }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Apply Calming Factors")
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundColor(.green)
                                
                                let layout = isiPhone ? AnyLayout(VStackLayout(spacing: 12)) : AnyLayout(HStackLayout(spacing: 12))
                                
                                layout {
                                    ExploreButton(title: "Meds", color: .green) { brain.calmDown(0.3) }
                                    ExploreButton(title: "Rest", color: .blue) { brain.calmDown(0.2) }
                                    ExploreButton(title: "Mindfulness", color: .mint) { brain.calmDown(0.15) }
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Reset Button
                        Button(action: {
                            withAnimation(.spring()) {
                                brain.activityLevel = 0.2
                                brain.stopHaptics()
                            }
                        }) {
                            Text("Reset Simulation")
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                                .foregroundColor(.blue)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.blue.opacity(0.2), lineWidth: 1))
                                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 60)
                    }
                }
            }
        }
        .preferredColorScheme(.light)
        .onDisappear { brain.stopHaptics() }
    }
}

struct ExploreButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            withAnimation(.spring()) { action() }
        }) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                // --- LIQUID GLASS BUTTON RECIPE ---
                .background {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.5))
                        RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                    }
                }
                .background(color.opacity(0.08)) // Tint
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(colors: [.white, .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.04), radius: 10, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
