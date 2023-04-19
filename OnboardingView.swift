//
//  OnboardingView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/18/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("needsOnboarding") var needsOnboarding: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 25) {
            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(CGFloat(35))
                .shadow(radius: 5)
                .aspectRatio(contentMode: .fit)
            
            Text("Reframe")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(.linearGradient(colors: [Color(
                    UIColor(red: 0.502, green: 0.553, blue: 0.694, alpha: 1)), Color(UIColor(red: 0.196, green: 0.208, blue: 0.263, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            Spacer()
            
            Button {
                self.needsOnboarding = false
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Spacer()
                    Text("Get Started")
                        .foregroundColor(.white)
                    Spacer()
                }
                .frame(width: 350, height: 50)
                .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 15))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .padding(.top, 75)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {

        OnboardingView()
     
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("iPhone 14")

    }
}
