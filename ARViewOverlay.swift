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
    private func boxedControl(icon: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .font(.system(size: 20, weight: .medium))
                .frame(width: 55, height: 40)
                .background(Color.buttonGray, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func barOverlayControls() -> some View {
        HStack(spacing: 10) {
            boxedControl(icon: "plus") {
                Task {
                    await ARViewService.shared.randomFrame()
                }
            }
            .padding(.leading)
            boxedControl(icon: "camera") {
                ARViewService.shared.captureScreen()
            }
            Spacer()
        }
        .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
        .frame(height: 65)
        .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 15))
        .padding()
        .padding(.bottom, (UIDevice.current.userInterfaceIdiom == .pad) ? 50 : 100 )
    }
    
    @ViewBuilder
    private func selectedPictureOverlayControls() -> some View {
        HStack(spacing: 10) {
            
            boxedControl(icon: "photo") {
                arVM.bottomSheetState = .pictureSelection
            }
            .padding(.leading)
            
            boxedControl(icon: "rectangle.dashed") {
                arVM.bottomSheetState = .pictureSelection
            }
            
            boxedControl(icon: "paintbrush") {
                arVM.bottomSheetState = .pictureSelection
            }
            
            Menu {
                
                Button(role: .destructive) {
                    Task {
                        await ARViewService.shared.deleteEntity()
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }

            } label: {
                Image(systemName: "gearshape")
                    .foregroundColor(.gray)
                    .font(.system(size: 20, weight: .medium))
                    .frame(width: 55, height: 40)
                    .background(Color.buttonGray, in: RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button {
                ARViewModel.shared.userSelectedEntity = nil
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.gray)
                    .font(.title)
            }
            .padding(.trailing)
        }
        .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
        .frame(height: 65)
        .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 15))
        .padding()
        .padding(.bottom, (UIDevice.current.userInterfaceIdiom == .pad) ? 50 : 100 )
    }
    
    var body: some View {
                
        VStack(alignment: .leading) {
            
            Spacer()
                        
            VStack(alignment: .leading) {
                
                switch (arVM.bottomSheetState) {
                    case .none:
                        barOverlayControls()
                    case .pictureSelection:
                        PictureSelectionView()
                    case .userSelection:
                        selectedPictureOverlayControls()
                }
            }
            .padding([.top])
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
        .edgesIgnoringSafeArea([.top, .bottom])
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
        .previewDisplayName("iPad Pro 12.9-inch")
    }
}
