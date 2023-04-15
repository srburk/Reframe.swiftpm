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
    
//    @State private var showARTrackingModeIndicator: Bool = false
    
//    private func arCameraState() -> String {
//        switch(arVM.cameraTrackingState) {
//            case .limited(.excessiveMotion):
//                return "Excessive Motion"
//            case .limited(.initializing):
//                return "Initializing"
//            case .limited(.relocalizing):
//                return "Trying to Resume"
//            case .normal:
//                return "Availible"
//            case .notAvailable:
//                return "Not Availible"
//            default:
//                return "Too Dark"
//        }
//    }
    
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
                    await ARViewService.shared.randomFrame()
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
                
        VStack(alignment: .center) {
                        
            HStack {
                Spacer()
                capsuleOverlayControls()
            }
            .padding(.top, 50)
            .padding(.trailing, 20)
            
            Spacer()
            
//            if (showARTrackingModeIndicator) {
//                Label(arCameraState(), systemImage: "cube.transparent")
//                    .font(.system(size: 18))
//                    .padding([.top, .bottom], 5)
//                    .padding([.trailing, .leading], 15)
//                    .background(Color.lightGray, in: Capsule())
//                    .padding(.bottom, 20)
//            }
                        
            VStack(alignment: .center) {
                
                switch (arVM.bottomSheetState) {
                    case .none:
                        EmptyView()
                    case .pictureSelection:
                        PictureSelectionView()
                    case .userSelection:
                        FrameEditingView()
                }
            }
            .padding([.top, .leading])
            .padding(.bottom, 20)
            
            .frame(height: arVM.bottomSheetHeight)
            
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
