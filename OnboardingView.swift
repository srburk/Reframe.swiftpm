//
//  OnboardingView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/18/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("needsOnboarding") var needsOnboarding: Bool = true
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack {
                Spacer()
            }
            
            VStack(spacing: 20) {
                                
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            needsOnboarding = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.gray)
                            .font(.title)
                    }

                }
                
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .frame(width: 150, height: 150)
                    .cornerRadius(CGFloat(35))
//                    .shadow(radius: 5)
                    .aspectRatio(contentMode: .fit)
                
                Text("Reframe")
                    .font(.system(size: 40, weight: .semibold))
//                    .foregroundStyle(.linearGradient(colors: [Color(
//                        UIColor(red: 0.502, green: 0.553, blue: 0.694, alpha: 1)), Color(UIColor(red: 0.196, green: 0.208, blue: 0.263, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Text("Create real world gallerys with your favorite art")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                Text("Change frames and sizes in real time")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                Spacer()
            }
            .padding()
            .frame(width: (UIDevice.current.userInterfaceIdiom == .pad) ? 500 : 325, height: (UIDevice.current.userInterfaceIdiom == .pad) ? 600 : 450)
            .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 25))
            
            Spacer()
        }
        .background(.regularMaterial)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {

        ZStack {
            Color.cyan
            OnboardingView()
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("iPhone 14")
        
        ZStack {
            Color.cyan
            OnboardingView()
        }
        .previewDevice(PreviewDevice(rawValue: "iPad"))
        .previewDisplayName("iPad")

    }
}
