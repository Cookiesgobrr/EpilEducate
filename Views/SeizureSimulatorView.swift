//
//  SeizureSimulatorView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 07/02/2026.
//

import SwiftUI
import SpriteKit

struct SeizureSimulatorView: View {
    @ObservedObject var brain: BrainActivityModel
    @Binding var currentStage: FirstAidView.GameStage
    
    @State private var gameMessage = "Observe the person on the platform..."
    @State private var timeStarted = false
    @State private var cushionPlaced = false
    @State private var turnedOnSide = false
    
    @State private var startTime = Date()
    @State private var finalElapsedSeconds = 0
    @State private var scene = SeizureSimulatorScene()

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Image("metro")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .overlay(Color.black.opacity(0.35))
                    .ignoresSafeArea()
                
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .onAppear {
                        scene.size = geo.size
                        scene.scaleMode = .resizeFill
                        scene.backgroundColor = .clear
                    }
                    .ignoresSafeArea()
                
                VStack {
                    //T imer and instructions
                    VStack(spacing: 20) {
                        if timeStarted {
                            TimelineView(.animation(minimumInterval: 1.0)) { timeline in
                                let elapsed = turnedOnSide ? finalElapsedSeconds : Int(timeline.date.timeIntervalSince(startTime))
                                HStack(spacing: 12) {
                                    Image(systemName: "stopwatch.fill")
                                        .foregroundColor(.red)
                                        .symbolEffect(.pulse, value: elapsed)
                                    Text(formatTime(elapsed))
                                        .font(.system(size: 34, weight: .bold, design: .monospaced))
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(.ultraThinMaterial)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Capsule())
                            }
                            .padding(.top, 40)
                        } else {
                            Spacer().frame(height: 60)
                        }
                        
                        Text(gameMessage)
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(24)
                            .frame(maxWidth: 500)
                            .background(.ultraThinMaterial) // Modern glass effect
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(color: Color.black.opacity(0.2), radius: 10)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // actions
                    HStack(spacing: geo.size.width > 600 ? 50 : 25) {
                        GameBtn(title: "Time It", icon: "stopwatch", active: timeStarted) {
                            if scene.isSeizing {
                                startTime = Date()
                                withAnimation { timeStarted = true }
                                gameMessage = "Timing started. Protect the head!"
                            } else {
                                gameMessage = "Wait for the emergency to begin!"
                            }
                        }
                        
                        GameBtn(title: "Cushion", icon: "square.stack.3d.down.right.fill", active: cushionPlaced) {
                            if timeStarted {
                                scene.applyCushion()
                                withAnimation { cushionPlaced = true }
                                gameMessage = "Head protected! Wait for shaking to stop."
                            } else {
                                gameMessage = "Safety first! Start the timer."
                                scene.flashError()
                            }
                        }
                        
                        GameBtn(title: "Turn Side", icon: "person.fill.turn.right", active: turnedOnSide) {
                            if cushionPlaced {
                                if scene.person?.action(forKey: "seizure_shake") != nil {
                                    gameMessage = "Wait! Don't move them while they're shaking!"
                                    scene.flashError()
                                } else {
                                    finalElapsedSeconds = Int(Date().timeIntervalSince(startTime))
                                    scene.rollToSide()
                                    withAnimation { turnedOnSide = true }
                                    gameMessage = "Great job. They are in the recovery position."
                                    
                                    // end haptic
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        withAnimation { currentStage = .results(time: finalElapsedSeconds) }
                                    }
                                }
                            } else {
                                gameMessage = "Protect the head before turning!"
                                scene.flashError()
                            }
                        }
                    }
                    .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                }
            }
        }
        .onAppear { brain.activityLevel = 0.95 }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct GameBtn: View {
    let title: String
    let icon: String
    let active: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon).font(.title2)
                Text(title).font(.system(size: 11, weight: .bold, design: .rounded))
            }
            .frame(width: 95, height: 95)
            .background(active ? Color.green : Color.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(color: (active ? Color.green : Color.blue).opacity(0.3), radius: 6, y: 3)
        }
        .disabled(active)
        .scaleEffect(active ? 0.9 : 1.0)
    }
}
