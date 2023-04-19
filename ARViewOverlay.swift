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
    
//    @ObservedObject var arVM: ARViewModel = ARViewModel.shared
    @ObservedObject var virtualGallery = VirtualGallery.shared
    
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
                virtualGallery.bottomSheetState = .newFrame
            }
            .padding(.leading)
            boxedControl(icon: "camera.fill", description: "Capture") {
                virtualGallery.captureScreen()
            }
            
            Spacer()
            
            boxedControl(icon: "person.2.fill", description: "Connect") {
                virtualGallery.debugReport()
            }
            .padding(.trailing)
        }
    }
    
    @ViewBuilder
    private func selectedPictureOverlayControls() -> some View {
        OverlayBarView {

            boxedControl(icon: "photo.fill", description: "Image") {
                virtualGallery.bottomSheetState = .pictureSelection
            }
            .padding(.leading)
            
            boxedControl(icon: "rectangle.inset.filled", description: "Frame") {
                virtualGallery.bottomSheetState = .frameSelection
            }
            
            Menu {
                Button(role: .destructive) {
                    Task {
//                        await ARViewService.shared.deleteEntity()
//                        if let selectedEntity = arVM.userSelectedObject {
//                            VirtualGallery.shared.removeObject(selectedEntity)
//                        }
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
                virtualGallery.selectedGalleryObject.isSelected = false
                virtualGallery.isObjectSelected = false
            }
            .padding(.trailing)
        }
    }
    
    var body: some View {
                
        VStack(alignment: .leading) {
            
            HStack {
                Spacer()
            }
            .padding(.top, 55)
            
            Spacer()
                   
            VStack(alignment: .leading) {
                
                switch (virtualGallery.bottomSheetState) {
                    case .normal:
                        if (virtualGallery.isObjectSelected) {
                            selectedPictureOverlayControls()
                        } else {
                            barOverlayControls()
                        }
                    case .pictureSelection:
                        PictureSelectionView(galleryObject: virtualGallery.selectedGalleryObject)
                    case .frameSelection:
                        FrameSelectionView(galleryObject: virtualGallery.selectedGalleryObject)
                    case .newFrame:
                        NewFrameView()
                }
            }
            .padding([.top])
            .padding(.bottom, 20)
            
            .frame(height: virtualGallery.bottomSheetState.bottomSheetHeight())
            
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            
            .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 20))
            
            .padding(.bottom, (UIDevice.current.userInterfaceIdiom == .pad) ? 28 : 0)
            .padding(.leading, (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 0)
        }
        
        .overlay {
            if (VirtualGallery.shared.loadingNewObject) {
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
