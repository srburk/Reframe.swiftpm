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
class GalleryView: ARView {
    
    required init(frame: CGRect) {
        
        #if targetEnvironment(simulator)
            super.init(frame: .zero)
        #else
            super.init(frame: frame, cameraMode: .ar, automaticallyConfigureSession: true)
        #endif
        
        let mainAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: .zero))
        
        arView.renderOptions = .disableAREnvironmentLighting
        arView.renderOptions = .disableMotionBlur
        
        arView.scene.anchors.append(mainAnchor)
        
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
