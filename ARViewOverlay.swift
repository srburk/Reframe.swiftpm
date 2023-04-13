//
//  ARViewOverlay.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import SwiftUI
import ARKit

struct ARSelectionView: View {
    
    @ViewBuilder
    private func arEditingButton(systemName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray)
                .foregroundColor(.clear)
            
            Image(systemName: systemName)
                .font(.system(size: 35))
                .foregroundColor(.primary)
        }
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 20) {
            arEditingButton(systemName: "photo")
            arEditingButton(systemName: "photo.artframe")
            arEditingButton(systemName: "square.inset.filled")
        }
        
        Spacer()
    }
}

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
    
    @ViewBuilder
    private func capsuleOverlayControls() -> some View {
        VStack(alignment: .center, spacing: 15) {
            Button {
                ARViewService.shared.captureScreen()
            } label: {
                Image(systemName: "camera.shutter.button")
                    .foregroundColor(.black)
            }
            
            Divider()
                        
            Button {
                Task {
                    await ARViewService.shared.newFrame()
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.black)
            }

        }
        .frame(width: 40, height: 100)
        .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 20))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
                        
            HStack {
                Spacer()
                capsuleOverlayControls()
            }
            .padding(.top, 50)
            .padding(.trailing, 20)
            
            Spacer()
                        
            VStack(alignment: .center) {
                
                HStack(alignment: .center) {
                    Text("4in x 8in")
                    
                    Spacer()
                    
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                        .font(.system(size: 30))
                }
                
                ARSelectionView()
                                
            }
            .padding()
            .padding(.bottom, 5)
            .frame(height: 200)
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            
            .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 20))
            
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
