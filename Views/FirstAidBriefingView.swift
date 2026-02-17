import SwiftUI

struct FirstAidBriefingView: View {
    @Binding var currentStage: FirstAidView.GameStage
    @State private var stepIndex = 0
    
    let tutorialSteps = [
        TutorialStep(title: "STAY", icon: "clock.fill", color: .blue, desc: "Stay with the person and time the seizure. If it lasts more than 5 minutes, call 911/999."),
        TutorialStep(title: "SAFE", icon: "shield.fill", color: .orange, desc: "Keep them safe by moving harmful objects away and putting something soft under their head."),
        TutorialStep(title: "SIDE", icon: "person.fill.turn.right", color: .green, desc: "Once the shaking stops, gently turn them onto their side to keep their airway clear.")
    ]
    
    var body: some View {
        ZStack {
            // Force the pure white background
            Color.white.ignoresSafeArea()
            
            // Ambient blue glow to show through the glass
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(x: 150, y: -300)
            
            VStack(spacing: 30) {
                Text("What do you do if you witness a seizure?")
                    .font(.system(.title, design: .monospaced, weight: .heavy))
                    .padding(.top, 40)
                    .accessibilityAddTraits(.isHeader)
                
                ZStack {
                    ForEach(0..<tutorialSteps.count, id: \.self) { index in
                        if index == stepIndex {
                            VStack(spacing: 25) {
                                // Icon with glowing backdrop
                                Image(systemName: tutorialSteps[index].icon)
                                    .font(.system(size: 70))
                                    .foregroundColor(tutorialSteps[index].color)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(tutorialSteps[index].color.opacity(0.1))
                                            .blur(radius: 20)
                                    )
                                    .accessibilityHidden(true)
                                
                                Text(tutorialSteps[index].title)
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(tutorialSteps[index].desc)
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .foregroundColor(.black.opacity(0.7))
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 380)
                            // --- LIQUID GLASS RECIPE ---
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.white.opacity(0.5))
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(.ultraThinMaterial)
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.white, .white.opacity(0.4), .clear],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2.5
                                    )
                            )
                            .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 10)
                            // ---------------------------
                            .padding(.horizontal, 24)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        }
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: stepIndex)
                
                // Progress Dots
                HStack(spacing: 12) {
                    ForEach(0..<tutorialSteps.count, id: \.self) { index in
                        Capsule()
                            .fill(index == stepIndex ? tutorialSteps[index].color : Color.black.opacity(0.1))
                            .frame(width: index == stepIndex ? 24 : 8, height: 8)
                    }
                }
                .padding(.vertical, 10)
                
                Spacer()
                
                // Navigation Button
                Button(action: {
                    withAnimation {
                        if stepIndex < tutorialSteps.count - 1 {
                            stepIndex += 1
                        } else {
                            currentStage = .simulator
                        }
                    }
                }) {
                    Text(stepIndex < tutorialSteps.count - 1 ? "Next Step" : "Enter Simulator")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(tutorialSteps[stepIndex].color.gradient)
                        .clipShape(Capsule())
                        .shadow(color: tutorialSteps[stepIndex].color.opacity(0.3), radius: 10, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.light) // Ensures white background stays white
    }
}

// Ensure this struct is available to the view
struct TutorialStep: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let desc: String
}
