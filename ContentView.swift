//
//  ContentView.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import SwiftUI

struct ContentView: View {
    
    // Persistent
    @AppStorage("needsOnboarding") var needsOnboarding: Bool = true
    
    var body: some View {

            ZStack {
                ARViewContainer()
                ARViewOverlay()
                if (needsOnboarding) {
                    OnboardingView()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .prefersPersistentSystemOverlaysHidden()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")
    }
}
