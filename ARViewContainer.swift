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
                
    func makeUIView(context: Context) -> GalleryView {
        
        let arView = ARViewService.shared.arView
        
        arView.session.delegate = context.coordinator

        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func updateUIView(_ uiView: GalleryView, context: Context) {

    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        
        func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            ARViewModel.shared.cameraTrackingState = camera.trackingState
        }
        
    }
}
