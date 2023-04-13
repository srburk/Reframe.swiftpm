//
//  ARViewContainer.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer : UIViewRepresentable {
    
    @ObservedObject var arVM: ARViewModel = ARViewModel.shared
            
    func makeUIView(context: Context) -> GalleryView {
        
        let arView = ARViewService.shared.arView

        return arView
    }
    
    func updateUIView(_ uiView: GalleryView, context: Context) {
        DispatchQueue.main.async {
            arVM.cameraTrackingState = uiView.arView.session.currentFrame?.camera.trackingState ?? .notAvailable
        }
    }
}
