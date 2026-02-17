import SwiftUI

struct CalmView: View {
    @ObservedObject var brain: BrainActivityModel
    
    var body: some View {
        GeometryReader { geometry in
            let isiPhone = geometry.size.width < 500
            
            ZStack {
                // Layer 1: Pure White Base
                Color.white.ignoresSafeArea()
                
                // Layer 2: Subtle Ambient Glow
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .offset(x: -150, y: -200)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: isiPhone ? 25 : 40) {
                        
                        Text("Normal Activity")
                            .font(.system(size: isiPhone ? 28 : 34, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                            .padding(.top, isiPhone ? 20 : 40)
                        
                        // --- LIQUID GLASS NEURAL MONITOR ---
                        VStack {
                            NeuralView(brain: brain)
                                .frame(height: isiPhone ? 200 : 250)
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
                                    LinearGradient(colors: [.white, .white.opacity(0.5), .clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 10)
                        .padding(.horizontal)
                        
                        // --- LIQUID GLASS DESCRIPTION CARD ---
                        VStack(spacing: 16) {
                            Text("A healthy brain communicates via steady electrical pulses.")
                                .font(.system(isiPhone ? .body : .title3, design: .rounded, weight: .bold))
                                .foregroundColor(.blue)
                                .multilineTextAlignment(.center)
                            
                            Text("In a balanced brain, neurons fire in a steady, predictable rhythm. Think of it as a calm conversation where everyone speaks in turn.")
                                .font(.system(isiPhone ? .footnote : .body, design: .rounded, weight: .medium))
                                .foregroundColor(Color(white: 0.3))
                                .multilineTextAlignment(.center)
                        }
                        .padding(isiPhone ? 25 : 35)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.4))
                                RoundedRectangle(cornerRadius: 30).fill(.ultraThinMaterial)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(
                                    LinearGradient(colors: [.white, .clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 8)
                        .padding(.horizontal, isiPhone ? 20 : 30)
                        
                        // Disclaimer
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundStyle(.yellow)
                            Text("Simplified visual representation of brainwaves.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .italic()
                        }
                        .padding(.bottom, 30)
                    }
                    .frame(minWidth: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .preferredColorScheme(.light)
    }
}
