//
//  FirstAidView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 07/02/2026.
//

import SwiftUI
import SpriteKit

struct FirstAidView: View {
    @ObservedObject var brain: BrainActivityModel
    
    // state tracking gamestage
    @State private var currentStage: GameStage = .briefing
    @State private var gameScore = 0
    
    enum GameStage: Equatable {
        case briefing
        case simulator
        case results(time: Int)
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemGroupedBackground)
                .ignoresSafeArea()
            
             VStack(spacing: 0) {
                Group {
                    switch currentStage {
                    case .briefing:
                        FirstAidBriefingView(currentStage: $currentStage)
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading),
                                removal: .move(edge: .leading)
                            ))
                        
                    case .simulator:
                        SeizureSimulatorView(brain: brain, currentStage: $currentStage)
                            .transition(.opacity)
                        
                    case .results(let timeTaken):
                        GameResultsView(brain: brain, currentStage: $currentStage, finalTime: timeTaken)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        // animation
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentStage)
        .preferredColorScheme(.light)
    }
}
