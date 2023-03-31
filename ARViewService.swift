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
    
    func createFrame() async {
        
        do {
            let url = Bundle.main.url(forResource: "frame", withExtension: ".usdz")
            guard url != nil else { return }
            
            let loadedModelEntity = try Entity.loadModel(contentsOf: url!)
            guard let model = loadedModelEntity.model else { return }

            loadedModelEntity.model = ModelComponent(mesh: model.mesh, materials: [
                matteMaterial(),
                imageMaterial(),
                UnlitMaterial(color: .brown),
                frameMaterial()
            ])
            
            // MARK: Generate box to scale exactly with model
            loadedModelEntity.collision = CollisionComponent(shapes: [.generateBox(size: SIMD3(0.5, 0.5, 0.5))])
            
            guard let wallAnchor = arView.scene.anchors.first else { return }
            wallAnchor.addChild(loadedModelEntity)
            
            arView.installGestures([.scale, .translation], for: loadedModelEntity)

        } catch {
            print("Failed to load frame: \(error)")
        }
    }
    
    private func frameMaterial() -> Material {
        var frameMaterial = SimpleMaterial()
        
        frameMaterial.color = SimpleMaterial.BaseColor(tint: .black)
        frameMaterial.roughness = 0.5
        frameMaterial.metallic = 0.0
        
        return frameMaterial
    }
    
    private func matteMaterial() -> Material {
        var matteMaterial = SimpleMaterial()
        
        matteMaterial.color = SimpleMaterial.BaseColor(tint: .white)
        matteMaterial.roughness = 0.5
        matteMaterial.metallic = 0.0
        
        return matteMaterial
    }
    
    private func imageMaterial() -> Material {
        var imageMaterial = SimpleMaterial()
        
        imageMaterial.metallic = 0.0
        imageMaterial.roughness = 0.5
        
        if let texture = try? TextureResource.load(named: "MonaLisa") {
            imageMaterial.color = SimpleMaterial.BaseColor(tint: .white, texture: MaterialParameters.Texture(texture))
        }
        
        return imageMaterial
    }
}
