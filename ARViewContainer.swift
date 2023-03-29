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
        
        // Fix previews
        #if targetEnvironment(simulator)
        let arView = ARView(frame: .zero)
        #else
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        #endif
        
        // Set rendering options
        arView.renderOptions = .disableAREnvironmentLighting
        arView.renderOptions = .disableMotionBlur
        
        let wallAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: .zero))

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
        
        wallAnchor.addChild(plane)

        arView.scene.anchors.append(wallAnchor)
                        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        //
    }
}
