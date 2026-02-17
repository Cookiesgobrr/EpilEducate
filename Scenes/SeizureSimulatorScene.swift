import SpriteKit
import UIKit

class SeizureSimulatorScene: SKScene {
    var person: SKSpriteNode?
    var isSeizing = false
    
    // Properties for haptics
    private var hapticTimer: Timer?
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)

    enum Layer: CGFloat {
        case background = -2
        case platform = -1
        case cushion = 1
        case character = 2
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        setupEnvironment()
        setupCharacter()
        hapticGenerator.prepare()
    }
    
    func setupEnvironment() {
        self.removeAllChildren()
        let roadHeight = size.height * 0.25
        let bleedBuffer: CGFloat = 200
        let roadRect = CGRect(x: -size.width, y: -bleedBuffer, width: size.width * 2, height: roadHeight + bleedBuffer)
        let platform = SKShapeNode(rect: roadRect)
        platform.fillColor = .darkGray
        platform.strokeColor = .clear
        platform.position = CGPoint(x: frame.midX, y: 0)
        platform.zPosition = Layer.platform.rawValue
        addChild(platform)
        
        let line = SKShapeNode(rectOf: CGSize(width: size.width * 2, height: 10))
        line.fillColor = .systemYellow
        line.strokeColor = .clear
        line.position = CGPoint(x: frame.midX, y: roadHeight - 20)
        line.zPosition = Layer.platform.rawValue + 0.1
        addChild(line)
    }
    
    func setupCharacter() {
        let emojiLabel = SKLabelNode(text: "🧍‍♂️")
        emojiLabel.fontSize = 250
        let texture = view?.texture(from: emojiLabel)
        let character = SKSpriteNode(texture: texture)
        
        let visiblePlatformTop = (size.height * 0.40) / 2
        character.position = CGPoint(x: frame.midX, y: visiblePlatformTop + 200)
        character.zPosition = Layer.character.rawValue
        
        self.person = character
        addChild(character)
        
        run(SKAction.wait(forDuration: 1.5)) { [weak self] in
            self?.triggerEmergency()
        }
    }
    
    func triggerEmergency() {
        guard let person = person else { return }
        isSeizing = true
        let randomDuration = Double.random(in: 15...25)
        
        let fall = SKAction.rotate(toAngle: .pi / 2, duration: 0.4)
        let hitGround = SKAction.moveBy(x: 0, y: -60, duration: 0.4)
        
        person.run(SKAction.group([fall, hitGround])) { [weak self] in
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            
            DispatchQueue.main.async {
                self?.hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                    // makes sure haptics run safely without catching self
                    Task { @MainActor in
                        self?.hapticGenerator.impactOccurred(intensity: 0.7)
                    }
                }
            }
            
            let shake = SKAction.sequence([
                SKAction.moveBy(x: 3, y: 2, duration: 0.03),
                SKAction.moveBy(x: -3, y: -2, duration: 0.03)
            ])
            
            person.run(SKAction.repeatForever(shake), withKey: "seizure_shake")
            
            self?.run(SKAction.wait(forDuration: randomDuration)) {
                self?.stopHaptics()
                person.removeAction(forKey: "seizure_shake")
                person.run(SKAction.rotate(toAngle: .pi / 2, duration: 0.2))
            }
        }
    }
    
    // stopping timer
    private func stopHaptics() {
        hapticTimer?.invalidate()
        hapticTimer = nil
    }
    
    func applyCushion() {
        guard let p = person else { return }
        let label = SKLabelNode(text: "👕")
        label.fontSize = 75
        let texture = view?.texture(from: label)
        let cushion = SKSpriteNode(texture: texture)
        
        cushion.zPosition = Layer.cushion.rawValue
        cushion.position = CGPoint(x: p.position.x - 90, y: p.position.y - 15)
        cushion.alpha = 0
        cushion.setScale(0.1)
        addChild(cushion)
        
        cushion.run(SKAction.group([SKAction.fadeIn(withDuration: 0.2), SKAction.scale(to: 1.0, duration: 0.4)]))
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    func rollToSide() {
        guard let p = person else { return }
        let rotateSide = SKAction.rotate(byAngle: -.pi, duration: 0.8)
        let shift = SKAction.moveBy(x: 20, y: -5, duration: 0.8)
        p.run(SKAction.group([rotateSide, shift])) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    func flashError() {
        guard let p = person else { return }
        p.run(SKAction.sequence([SKAction.scale(to: 0.8, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1)]))
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }


    deinit {

    }
}
