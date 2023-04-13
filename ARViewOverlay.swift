//
//  ARViewOverlay.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import SwiftUI
import ARKit

struct ARViewOverlay: View {
    
    @ObservedObject var arVM: ARViewModel = ARViewModel.shared
    
    @ViewBuilder
    private func arCameraStateView() -> some View {
        switch(arVM.cameraTrackingState) {
            case .limited(.excessiveMotion):
                Text("Excessive Motion")
            case .limited(.initializing):
                Text("Initializing")
            case .limited(.relocalizing):
                Text("Trying to resume")
            case .normal:
                Text("Normal")
            case .notAvailable:
                Text("Not Availible")
            default:
                Text("Probably too dark")
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
                        
            HStack {
                Spacer()
                Button {
                    ARViewService.shared.captureScreen()
                } label: {
                    Image(systemName: "camera.shutter.button")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                        .padding(20)
                }
                .background(.regularMaterial)
                .clipShape(Circle())
            }
            .padding(.top, 50)
            .padding(.trailing, 10)
            
            Spacer()
                        
            VStack {
                
                arCameraStateView()
                
                Text((arVM.userSelectedEntity != nil) ? "Assigned Entity" : "No Entity")
                
                Button {
                    Task {
                        await ARViewService.shared.newFrame()
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing], 30)
                }
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            .frame(height: 200)
            
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            
            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20))
            
            .padding(.bottom, (UIDevice.current.userInterfaceIdiom == .pad) ? 28 : 0)
            .padding(.leading, (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 0)
        }
    }
}

struct ARViewOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.cyan
            ARViewOverlay()
        }
        .edgesIgnoringSafeArea(.all)
        
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("iPhone 14")
        
        ZStack {
            Color.cyan
            ARViewOverlay()
        }
        .edgesIgnoringSafeArea(.all)
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
        .previewDisplayName("iPad Pro 12.9-inch")
    }
}
