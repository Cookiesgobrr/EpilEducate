//
//  NeuralView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 07/02/2026.
//

import SwiftUI
import SpriteKit

class EEGScene: SKScene {
    var activityLevel: Double = 0.2
    private var wavePoints: [CGPoint] = []
    private let waveNode = SKShapeNode()
    private var xOffset: CGFloat = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        waveNode.lineWidth = 3
        waveNode.lineJoin = .round
        waveNode.lineCap = .round
        addChild(waveNode)
    }

    override func update(_ currentTime: TimeInterval) {
        let intensity = CGFloat(activityLevel)
        let midY = size.height / 2
        
        // speed up the scroll based on brain intensity
        xOffset += 2 + (intensity * 15)
        
        // layer two sine waves and some random spikes for the eeg look
        let layer1 = sin(xOffset * 0.12) * (30 + intensity * 60)
        let layer2 = sin(xOffset * 0.07) * (15 + intensity * 40)

        var spike: CGFloat = 0
        if CGFloat.random(in: 0...1) > (0.95 - (intensity * 0.5)) {
            spike = CGFloat.random(in: -80...80) * (0.5 + intensity)
        }
        
        let newY = midY + layer1 + layer2 + spike + CGFloat.random(in: -5...5)
        wavePoints.append(CGPoint(x: size.width, y: newY))

        // scroll left and remove points that are off-screen
        for i in 0..<wavePoints.count {
            wavePoints[i].x -= 4 + (intensity * 10)
        }
        wavePoints.removeAll(where: { $0.x < -20 })
        
        // update the line path
        let path = CGMutablePath()
        if let first = wavePoints.first {
            path.move(to: first)
            for point in wavePoints.dropFirst() { path.addLine(to: point) }
        }
        waveNode.path = path
        
        updateDynamicStyle(intensity: intensity)
    }

    private func updateDynamicStyle(intensity: CGFloat) {
        let displayColor: UIColor
        if intensity < 0.3 { displayColor = .systemCyan }
        else if intensity < 0.6 { displayColor = lerpColor(from: .systemCyan, to: .systemPurple, percent: (intensity - 0.3) / 0.3) }
        else if intensity < 0.85 { displayColor = lerpColor(from: .systemPurple, to: .systemOrange, percent: (intensity - 0.6) / 0.25) }
        else { displayColor = .systemRed }
        
        waveNode.strokeColor = displayColor
        waveNode.glowWidth = 2 + (intensity * 12)
        waveNode.alpha = intensity > 0.85 ? CGFloat.random(in: 0.6...1.0) : 1.0
    }

    private func lerpColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        from.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        to.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return UIColor(red: r1 + (r2 - r1) * percent, green: g1 + (g2 - g1) * percent, blue: b1 + (b2 - b1) * percent, alpha: a1 + (a2 - a1) * percent)
    }
}

struct NeuralView: View {
    @ObservedObject var brain: BrainActivityModel
    
    @State private var scene: EEGScene = {
        let s = EEGScene()
        s.size = CGSize(width: 600, height: 250)
        s.scaleMode = .fill
        return s
    }()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(brain.activityLevel > 0.8 ? Color.red.opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1.5)
                )

            SpriteView(scene: scene, options: [.allowsTransparency])
                .padding(.vertical, 5)
        }
        .frame(height: 180)
        .padding(.horizontal)
        .onAppear { scene.activityLevel = brain.activityLevel }
        .onChange(of: brain.activityLevel) { newValue in scene.activityLevel = newValue }
    }
}
