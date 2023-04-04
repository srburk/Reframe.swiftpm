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
        
        // MARK: Testing Frame Aspect Ratio Scaling
        let images = ["MonaLisa", "StarryNight", "GirlWithAPearlEarring"]
        
        let image = UIImage(named: images.randomElement()!, in: .main, with: .none)
        
        if let cgImage = image?.cgImage {
                        
            do {
                let url = Bundle.main.url(forResource: "simple-plastic", withExtension: ".usdz")
                guard url != nil else { return }
                
                let loadedModelEntity = try ModelEntity.loadModel(named: "simple-plastic", in: .main)
                
                guard let model = loadedModelEntity.model else { return }

//                let imageAspectRatio: Float = Float(cgImage.width) / Float(cgImage.height)
//                let loadedModelEntityAspectRatio = model.mesh.bounds.max.x / model.mesh.bounds.max.y
                
                loadedModelEntity.model = ModelComponent(mesh: model.mesh, materials: [
                    matteMaterial(),
                    imageMaterial(cgImage),
                    UnlitMaterial(color: .brown),
                    frameMaterial()
                ])
                
//                loadedModelEntity.scale = SIMD3(repeating: imageAspectRatio / loadedModelEntityAspectRatio)
                                
                // MARK: Generate box to scale exactly with model
//                loadedModelEntity.collision = CollisionComponent(shapes: [.generateBox(size: SIMD3(0.5, 0.5, 0.5))])
                loadedModelEntity.generateCollisionShapes(recursive: true)
                
                guard let wallAnchor = arView.scene.anchors.first else { return }
                wallAnchor.addChild(loadedModelEntity)
                
                arView.installGestures([.scale, .translation], for: loadedModelEntity)

            } catch {
                print("Failed to load frame: \(error)")
            }
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
    
    private func imageMaterial(_ image: CGImage) -> Material {
        var imageMaterial = SimpleMaterial()
        
        imageMaterial.metallic = 0.0
        imageMaterial.roughness = 0.5
        
        do {
            let texture = try TextureResource.generate(from: image, options: .init(semantic: .color))
            imageMaterial.color = SimpleMaterial.BaseColor(tint: .white, texture: MaterialParameters.Texture(texture))
        } catch {
            print("Error loading image")
        }
        
//        if let texture = try? TextureResource.load(named: "MonaLisa") {
//            imageMaterial.color = SimpleMaterial.BaseColor(tint: .white, texture: MaterialParameters.Texture(texture))
//        }
        
        return imageMaterial
    }
}
