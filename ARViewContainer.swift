//
//  ARViewContainer.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import SwiftUI
import RealityKit

struct ARViewContainer : UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        #if targetEnvironment(simulator)
        let arView = ARView(frame: .zero)
        #else
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        #endif
        
//        arView.renderOptions = .disableAREnvironmentLighting
//        arView.environment.background = .cameraFeed(exposureCompensation: .zero)
        
//        let wallAnchor = AnchorEntity(plane: .vertical, classification: .wall)
        let wallAnchor = AnchorEntity(plane: .horizontal, classification: .table)
        
        let plane = ModelEntity(mesh: .generatePlane(width: 0.1, depth: 0.1))
        
        wallAnchor.addChild(plane)

        arView.scene.anchors.append(wallAnchor)
                        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        //
    }
}
