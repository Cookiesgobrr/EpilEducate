import SwiftUI

// manages the global brain state and haptic alerts
@MainActor
class BrainActivityModel: ObservableObject {
    // default activity level (0.05 is baseline)
    @Published var activityLevel: Double = 0.05
    private var hapticTimer: Timer?
    
    // pushes the activity up when triggers occur
    func addStress(_ amount: Double) {
        withAnimation(.easeInOut(duration: 1.5)) {
            activityLevel = min(activityLevel + amount, 1.0)
        }
        checkHaptics()
    }
    
    // lowers activity level back to baseline
    func calmDown(_ amount: Double) {
        withAnimation(.easeInOut(duration: 1.5)) {
            activityLevel = max(activityLevel - amount, 0.05)
        }
        checkHaptics()
    }
    
    // if the phone should vibrate based on intensity of brainwave
    private func checkHaptics() {
        if activityLevel > 0.85 {
            startHaptics()
        } else {
            stopHaptics()
        }
    }
    
    // starts a repeating haptic for high activity phases
    private func startHaptics() {
        if hapticTimer == nil {
            hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                Task { @MainActor in
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                }
            }
        }
    }
    
    // kills the haptic timer
    func stopHaptics() {
        hapticTimer?.invalidate()
        hapticTimer = nil
    }
}
