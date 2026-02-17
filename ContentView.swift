import SwiftUI

struct ContentView: View {
    @StateObject var sharedBrain = BrainActivityModel()
    @State private var showingBriefing = true
    
    var body: some View {
        GeometryReader { geometry in
            let isiPhone = geometry.size.width < 500
            
            TabView {
                // part 1: intro and my story
                WelcomeView()
                StoryView()
                BriefingView(showBriefing: $showingBriefing)
  
                
                // part 2: different brain views, triggers
                CalmView(brain: sharedBrain)
                TriggerView(brain: sharedBrain)
                RecoveryView(brain: sharedBrain)
                
                // part 3: explore mode
                ExploreView(brain: sharedBrain)
                
                // part 4: minigame
                FirstAidView(brain: sharedBrain)
                    .id("FirstAidGame")
                
                SeizureImpactView()


            }
            .tabViewStyle(.page(indexDisplayMode: isiPhone ? .never : .always))
            .ignoresSafeArea() //fix for part 4 where the bridge wasnt filling the entire screen
            .background(Color(UIColor.white))
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
