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
        
        arView.renderOptions = .disableAREnvironmentLighting
        arView.renderOptions = .disableMotionBlur
        
        let wallAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: .zero))

        
        arView.scene.anchors.append(wallAnchor)
        
//        Task {
//            await addMonaLisa()
//        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var arView: ARView { return self }
    
    @MainActor override dynamic func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard !touches.isEmpty else { return }
        let tappedLocation = touches.first!.location(in: arView)
        if let tappedEntity = arView.entity(at: tappedLocation) {
            let scaleFactor: Float = 1.0
            tappedEntity.scale = SIMD3(scaleFactor, scaleFactor, scaleFactor)
        } else {
            print("No entity at location: \(tappedLocation)")
        }
    }
    
    func addMonaLisa() async {
        var imageMaterial = SimpleMaterial()

        if let texture = try? TextureResource.load(named: "MonaLisa") {
            print("Loaded texture")
            imageMaterial.color = SimpleMaterial.BaseColor(tint: .white, texture: MaterialParameters.Texture(texture))
        }
        
        imageMaterial.metallic = 0.0
        imageMaterial.roughness = 0.5
        
        let plane = ModelEntity(mesh: .generatePlane(width: 0.05, height: 0.0745), materials: [imageMaterial])
        
        let angle = -90 * (Float.pi / 180)
        let rotationMatrix = float4x4([1, 0, 0, 0],
                                      [0, cos(angle), sin(angle), 0],
                                      [0, -sin(angle), cos(angle), 0],
                                      [0, 0, 0, 1])
        
        plane.orientation = simd_quatf(rotationMatrix)
        let scaleFactor: Float = 8.0
        plane.scale = SIMD3(scaleFactor, scaleFactor, scaleFactor)
        plane.position = SIMD3()
        
        plane.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: SIMD3(0.05, 0.0745, 0.0))])
                
        guard let wallAnchor = arView.scene.anchors.first else { return }
        wallAnchor.addChild(plane)
        
    }
}
