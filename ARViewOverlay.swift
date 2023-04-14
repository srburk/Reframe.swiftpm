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
    private func arEditingButton(systemName: String, bottomSheetMode: BottomSheetState) -> some View {
        
        Button {
            ARViewModel.shared.bottomSheetState = bottomSheetMode
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray)
                    .foregroundColor(.clear)
                
                Image(systemName: systemName)
                    .font(.system(size: 35))
                    .foregroundColor(.primary)
            }
        }
    }
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                
                Text("Options – \((ARViewModel.shared.userSelectedEntity != nil) ? "Selected" : "N/A")")
                    .font(.headline)
                
                Menu {
                    Text("Option 1")
                    Text("Option 2")
                } label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .foregroundColor(.gray)
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                }

                Spacer()
                
                Button {
                    ARViewModel.shared.userSelectedEntity = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                        .font(.title)
                }
            }
            
            HStack(alignment: .center, spacing: 20) {
                arEditingButton(systemName: "photo", bottomSheetMode: .pictureSelection)
                arEditingButton(systemName: "photo.artframe", bottomSheetMode: .pictureSelection)
                arEditingButton(systemName: "square.inset.filled", bottomSheetMode: .pictureSelection)
            }
            
            Spacer()
        }
    }
}

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
                        ARSelectionView()
                }
            }
            .padding()
            .padding(.bottom, 5)
            
            .frame(height: arVM.bottomSheetHeight)
            
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            
            .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 20))
            
            .padding(.bottom, (UIDevice.current.userInterfaceIdiom == .pad) ? 28 : 0)
            .padding(.leading, (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 0)
            
            // MARK: Camera state capsule
//            .onChange(of: arVM.bottomSheetState) { _ in
//                print(arCameraState())
//                withAnimation {
//                    showARTrackingModeIndicator = true
//                }
//                Task {
//                    try await Task.sleep(nanoseconds: 3_000_000_000)
//                    withAnimation {
//                        showARTrackingModeIndicator = false
//                    }
//                }
//            }
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
