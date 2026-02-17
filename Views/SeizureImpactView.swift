import SwiftUI

struct SeizureImpactView: View {
    @State private var animateIn = false
    
    var body: some View {
        ZStack {
            // Force pure white base
            Color.white.ignoresSafeArea()
            
            // Ambient Blobs (Visual interest for the glass to pick up)
            Circle()
                .fill(Color.blue.opacity(0.12))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(x: -150, y: -200)

            ScrollView {
                VStack(spacing: 30) { // Reduced spacing for a tighter look
                    VStack(alignment: .leading, spacing: 8) {
                        Text("More about Epilepsy")
                            .font(.system(size: 40, weight: .black, design: .monospaced))
                            .foregroundColor(.black)
                        
                        Rectangle()
                            .frame(width: 60, height: 4)
                            .foregroundStyle(.blue.gradient)
                            .cornerRadius(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 40)

                    ImpactMetricCard(
                        number: "70%",
                        description: "of people living with epilepsy could live seizure-free if they had access to proper diagnosis and treatment.",
                        icon: "checkmark.shield.fill",
                        color: .green,
                        delay: 0.2
                    )
                    
                    ImpactMetricCard(
                        number: "150K",
                        description: "new cases of epilepsy diagnosed in the US in a year.",
                        icon: "stethoscope",
                        color: .red,
                        delay: 0.4
                    )

                    ImpactMetricCard(
                        number: "50M",
                        description: "people worldwide live with epilepsy, making it one of the most common neurological diseases globally.",
                        icon: "globe.americas.fill",
                        color: .purple,
                        delay: 0.6
                    )
                    
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(.yellow)
                        Text("Most seizures are not medical emergencies if you know the Stay, Safe, Side steps.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Capsule().stroke(Color.gray.opacity(0.2)))
                    .padding(.vertical, 20)
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

struct ImpactMetricCard: View {
    let number: String
    let description: String
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var show = false
    
    var body: some View {
        HStack(spacing: 20) {
            // Icon with a soft glow
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(color.gradient)
                .frame(width: 80)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                        .blur(radius: 10)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(number)
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(color)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Color.black.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(25)
        .frame(maxWidth: .infinity)
        // --- THE LIQUID GLASS RECIPE ---
        .background {
            ZStack {
                // Base Material
                RoundedRectangle(cornerRadius: 30)
                    .fill(.white.opacity(0.4))
                
                // Frosted Effect
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
            }
        }
        // Shine/Border
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.5), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        // Shadow for depth
        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 10)
        .padding(.horizontal)
        // ------------------------------
        .offset(y: show ? 0 : 30)
        .opacity(show ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay)) {
                show = true
            }
        }
    }
}
