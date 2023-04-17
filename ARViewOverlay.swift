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
//    
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
    
    struct OverlayBarView<Content: View>: View {
        @ViewBuilder var content: Content
        
        var body: some View {
            HStack(spacing: 10) {
                content
            }
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            .frame(height: 80)
            .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 15))
            .padding()
            .padding(.bottom, (UIDevice.current.userInterfaceIdiom == .pad) ? 75 : 125 )
        }
    }
    
    @ViewBuilder
    private func boxedControl(icon: String, description: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 5) {
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
            
            Text(description)
                .foregroundColor(.gray)
                .font(.system(size: 12))
        }
        .padding(.top, 5)
    }
    
    @ViewBuilder
    private func barOverlayControls() -> some View {
        OverlayBarView {
            boxedControl(icon: "plus", description: "New") {
//                arVM.bottomSheetState = .newFrame
//                Task {
//                    await ARViewService.shared.randomFrame()
//                }
                Task {
                    
                    if let image = UIImage(named: ContentService.images.historical.randomElement() ?? "") {
                        if let frameURL = Bundle.main.url(forResource: "wood-frame", withExtension: ".usdz") {
                            let newObject = VirtualGallery.GalleryObject(image: image, frameURL: frameURL, matteSize: 0.8)
                            await VirtualGallery.shared.addObject(newObject)
                        }
                    }
                }
            }
            .padding(.leading)
            boxedControl(icon: "camera.fill", description: "Capture") {
                ARViewService.shared.captureScreen()
            }
            
            Spacer()
            
            boxedControl(icon: "person.2.fill", description: "Connect") {
                VirtualGallery.shared.debugReport()
            }
            .padding(.trailing)
        }
    }
    
    @ViewBuilder
    private func selectedPictureOverlayControls() -> some View {
        OverlayBarView {

            boxedControl(icon: "photo.fill", description: "Image") {
                arVM.bottomSheetState = .pictureSelection
            }
            .padding(.leading)
            
            boxedControl(icon: "rectangle.inset.filled", description: "Frame") {
                arVM.bottomSheetState = .frameSelection
            }
            
            Menu {
                Button(role: .destructive) {
                    Task {
//                        await ARViewService.shared.deleteEntity()
                        if let selectedEntity = arVM.userSelectedObject {
                            VirtualGallery.shared.removeObject(selectedEntity)
                        }
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                
            } label: {
                VStack(spacing: 5) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 20, weight: .medium))
                        .frame(width: 55, height: 40)
                        .background(Color.buttonGray, in: RoundedRectangle(cornerRadius: 8))
                    Text("Options")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
            }
            .menuStyle(.borderlessButton)
            .padding(.top, 5)
            
            Spacer()
            
            boxedControl(icon: "arrow.up.backward", description: "Back") {
                arVM.bottomSheetState = .none
            }
            .padding(.trailing)
        }
    }
    
    var body: some View {
                
        VStack(alignment: .leading) {
            
            HStack {
                
                Button {
                    // settings?
                    VirtualGallery.shared.debugReport()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.gray)
                        .symbolRenderingMode(.hierarchical)
                }
                .padding(5)
                .background(Color.lightGray, in: Ellipse())
                .buttonStyle(.plain)
                .padding(.leading)

//                Spacer()
//                if (showARTrackingModeIndicator) {
//                    Label(arCameraState(), systemImage: "cube.transparent")
//                        .font(.system(size: 18))
//                        .padding([.top, .bottom], 5)
//                        .padding([.trailing, .leading], 15)
//                        .background(Color.lightGray, in: Capsule())
//                }
                Spacer()
            }
            .padding(.top, 55)
            
//             // MARK: Camera state capsule
//            if #available(iOS 16.0, *) {
//                EmptyView()
//                .onChange(of: arVM.cameraTrackingState) { _ in
//                    withAnimation {
//                        showARTrackingModeIndicator = true
//                    }
//                    Task {
//                        try await Task.sleep(nanoseconds: 4_000_000_000)
//                        withAnimation {
//                            showARTrackingModeIndicator = false
//                        }
//                    }
//                }
//            } else {
//            }
            
            Spacer()
                   
            VStack(alignment: .leading) {
                
                switch (arVM.bottomSheetState) {
                    case .none:
                        barOverlayControls()
                    case .pictureSelection:
                        PictureSelectionView()
                    case .frameSelection:
                        FrameSelectionView()
                    case .userSelection:
                        selectedPictureOverlayControls()
                    case .newFrame:
                        NewFrameView()
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
        
        .overlay {
            if (arVM.loadingNewObject) {
                ProgressView()
            }
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
