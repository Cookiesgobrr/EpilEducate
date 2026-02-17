//
//  StoryView.swift
//  EpilEducate
//
//  Created by Tarun Abraham on 07/02/2026.
//

import SwiftUI

struct StoryView: View {
    var body: some View {
        GeometryReader { geometry in
            let isiPhone = geometry.size.width < 500
            let screenHeight = geometry.size.height
            
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                // Soft background glow
                Circle()
                    .fill(Color.blue.opacity(0.08))
                    .frame(width: isiPhone ? 300 : 500, height: isiPhone ? 300 : 500)
                    .blur(radius: isiPhone ? 60 : 100)
                    .offset(x: isiPhone ? -100 : -150, y: -200)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: isiPhone ? 20 : 40) {
                        
                        // Main Card
                        VStack(alignment: .center, spacing: isiPhone ? 20 : 25) {
                            
                            // Adaptive Size
                            Group {
                                if let uiImage = UIImage(named: "me") {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .foregroundColor(.gray.opacity(0.2))
                                }
                            }
                            // iphone size adapts
                            .frame(width: isiPhone ? 180 : 300, height: isiPhone ? 180 : 300)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.white, lineWidth: 4))
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                            .padding(.top, 10)
                            
                            Text("MY STORY")
                                .font(.system(isiPhone ? .caption2 : .caption, design: .rounded, weight: .black))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1), in: Capsule())
                                .foregroundColor(.blue)

                            VStack(spacing: 15) {
                                Text("In 2023, when I was 15, I had a seizure in my bathroom. It was a very scary experience, and it made me realize how little most people know about epilepsy.")
                                    .font(.system(size: isiPhone ? 18 : 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                
                                Text("I created this submission for the Swift Student Challenge to give you a hands-on look at what happens in the brain during a seizure, and to teach you how to help if you ever witness one.")
                                    .font(.system(isiPhone ? .footnote : .body, design: .rounded, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(isiPhone ? 4 : 6)
                            }
                        }
                        .padding(isiPhone ? 25 : 40)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 40))
                        .overlay(RoundedRectangle(cornerRadius: 40).stroke(.white, lineWidth: 2))
                        .shadow(color: .black.opacity(0.06), radius: 30, x: 0, y: 15)
                        .padding(.horizontal, isiPhone ? 20 : 25)
                        .padding(.top, isiPhone ? 40 : 60)
                        
                        Text("Swipe to enter simulation →")
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                            .foregroundColor(.blue.opacity(0.6))
                            .padding(.vertical, 20)
                    }
                    .frame(minHeight: screenHeight) // ensures "Swipe" stays at bottom if screen is MASSIVE
                }
            }
        }
        .preferredColorScheme(.light)
    }
}
