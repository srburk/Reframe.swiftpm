//
//  GalleryView.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import RealityKit
import ARKit

// MARK: Maybe keep as seperate class for handling certain events?
class GalleryView: ARView, ARSessionDelegate {
    
    required init(frame: CGRect) {
        
        #if targetEnvironment(simulator)
            super.init(frame: .zero)
        #else
            super.init(frame: frame, cameraMode: .ar, automaticallyConfigureSession: false)
        #endif
        
        let mainAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: .zero))
        mainAnchor.name = "MainWallAnchor"
        
        arView.renderOptions = .disableAREnvironmentLighting
        arView.renderOptions = .disableMotionBlur
        
        arView.session.delegate = self
        
        arView.scene.anchors.append(mainAnchor)
                
        let sessionConfiguration = ARWorldTrackingConfiguration()
        sessionConfiguration.planeDetection = [.vertical]
        sessionConfiguration.frameSemantics = .personSegmentationWithDepth
        
        arView.session.run(sessionConfiguration, options: .resetTracking)
        
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        if arView.scene.anchors.contains(where: {
//            $0.name == "MainWallAnchor"
//        }) {
//            print("Added anchor")
//        }
//    }
    
    var arView: ARView { return self }
    
    @MainActor override dynamic func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard !touches.isEmpty else { return }
        let tappedLocation = touches.first!.location(in: arView)
        if let tappedEntity = arView.entity(at: tappedLocation) {
//            let scaleFactor: Float = 1.0
//            tappedEntity.scale = SIMD3(scaleFactor, scaleFactor, scaleFactor)
        } else {
            print("No entity at location: \(tappedLocation)")
        }
    }
}
