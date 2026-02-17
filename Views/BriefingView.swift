import SwiftUI

struct BriefingView: View {
    @Binding var showBriefing: Bool
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Circle()
                .fill(Color.blue.opacity(0.12))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(x: -150, y: -200)
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Understanding Epilepsy")
                            .font(.system(size: 32, weight: .black, design: .monospaced))
                            .foregroundColor(.black) // Strict black text
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 40)
                    
                    BriefingCard(
                        title: "Seizures",
                        icon: "bolt.horizontal.circle.fill",
                        color: .orange,
                        text: "A seizure is a sudden, uncontrolled surge of electrical activity between brain cells."
                    )
                    
                    BriefingCard(
                        title: "The Seizure Threshold",
                        icon: "waveform.path.ecg",
                        color: .blue,
                        text: "This represents the amount of electrical activity required to trigger a seizure. It varies greatly from person to person."
                    )
                    
                    BriefingCard(
                        title: "Impact",
                        icon: "person.3.sequence.fill",
                        color: .green,
                        text: "Epilepsy is the fourth most common neurological disorder. 1 in 26 people will develop it in their lifetime."
                    )
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct BriefingCard: View {
    let title: String
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3.bold())
                    .foregroundColor(color)
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.black)
            }
            
            Text(text)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundColor(Color(white: 0.3))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.1), lineWidth: 1) 
        )
    }
}
