//
//  GameResultsView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 07/02/2026.
//

import SwiftUI

struct GameResultsView: View {
    @ObservedObject var brain: BrainActivityModel
    @Binding var currentStage: FirstAidView.GameStage
    var finalTime: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 15) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.green.gradient)
                    .symbolEffect(.pulse)
                
                Text("Life Saved.")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                
                Text("You are now better prepared to handle a person encountering a seizure.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    // Box 1: STAY
                    ResultCard(title: "STAY",
                               icon: "clock.fill",
                               color: .orange,
                               desc: "Timed Seizure: \(formatTime(finalTime))")
                    
                    // Box 2: SAFE
                    ResultCard(title: "SAFE",
                               icon: "shield.fill",
                               color: .blue,
                               desc: "Soft material placed")
                }
                
                // Box 3: SIDE (take full width of screen)
                ResultCard(title: "SIDE",
                           icon: "person.fill.turn.right",
                           color: .green,
                           desc: "Person turned to side",
                           isWide: true)
            }
            .padding(.horizontal)

            Text("If you ever witness a real seizure, also remember to stay calm and never put anything in the person's mouth.")
                .font(.caption)
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    brain.activityLevel = 0.2
                    currentStage = .briefing
                }
            }) {
                HStack {
                    Text("Restart Simulator")
                    Image(systemName: "arrow.counterclockwise")
                }
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
        .onAppear {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ResultCard: View {
    let title: String
    let icon: String
    let color: Color
    let desc: String
    var isWide: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Spacer()
                Text(title)
                    .font(.caption.bold())
            }
            .foregroundColor(color)
            
            Text(desc)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxHeight: .infinity, alignment: .topLeading)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
