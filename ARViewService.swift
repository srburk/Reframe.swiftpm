//
//  ARViewService.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import RealityKit
import UIKit

@MainActor
final class ARViewService {
    
    static var shared = ARViewService()
    
    let arView = GalleryView(frame: .zero)
    
    func captureScreen() {
        arView.snapshot(saveToHDR: false) { image in
            guard (image != nil) else { return }
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }
    
    func showAnchorIndicator() async {
        guard let wallAnchor = arView.scene.anchors.first else { return }
        
        let indicatorMaterial = UnlitMaterial(color: .blue)
        let indicatorEntity = ModelEntity(mesh: .generateBox(size: 0.05), materials: [indicatorMaterial])
        indicatorEntity.position = SIMD3(0.0, 0.0, 0.0)
        
        wallAnchor.addChild(indicatorEntity)
    }
    
    func loadPainting() {
        
        guard let wallAnchor = arView.scene.anchors.first else { return }
        
        print("Started load painting")
        
        _ = Entity.loadModelAsync(named: "newFrame")
            .sink(receiveCompletion: { loadCompletion in
                print("Error loading model")
            }, receiveValue: { entity in
                print("Found model")
                self.arView.installGestures(.all, for: entity)
                wallAnchor.addChild(entity)
            })
    }
}
