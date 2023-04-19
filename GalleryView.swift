//
//  GalleryView.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI
import MultipeerConnectivity

// MARK: Maybe keep as seperate class for handling certain events?
class GalleryView: ARView {
    
    static var defaultSessionConfig: ARConfiguration {
        let sessionConfiguration = ARWorldTrackingConfiguration()
        sessionConfiguration.planeDetection = [.vertical]
        sessionConfiguration.frameSemantics = .personSegmentationWithDepth
        sessionConfiguration.isCollaborationEnabled = true
        return sessionConfiguration
    }
        
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
                
        arView.scene.anchors.append(mainAnchor)
        
        arView.scene.synchronizationService = try? MultipeerConnectivityService(session: MultipeerService.shared.session)
        
        arView.session.run(GalleryView.defaultSessionConfig, options: .resetTracking)
        
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var arView: ARView { return self }
    
    @MainActor override dynamic func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !touches.isEmpty else { return }
        if let tappedObject = arView.entity(at: touches.first!.location(in: arView)) {
            if let associatedVirtualObject = VirtualGallery.shared.collection.first(where: { $0.id.uuidString == tappedObject.name }), !associatedVirtualObject.isSelected {
                
                if (VirtualGallery.shared.isObjectSelected) {
                    VirtualGallery.shared.selectedGalleryObject.isSelected = false
                }
                VirtualGallery.shared.isObjectSelected = true
                associatedVirtualObject.isSelected = true
            }
        } else {
            if VirtualGallery.shared.isObjectSelected {
                VirtualGallery.shared.selectedGalleryObject.isSelected = false
                VirtualGallery.shared.isObjectSelected = false
            } else {
                VirtualGallery.shared.bottomSheetState = .normal
            }
        }
    }
}
