//
//  ARViewService.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import RealityKit
import UIKit
import Combine

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
    
    func deleteEntity() async {
        guard let wallAnchor = self.arView.scene.anchors.first else { return }
        guard let selectedEntity = ARViewModel.shared.userSelectedEntity else { return }
        wallAnchor.removeChild(selectedEntity)
        ARViewModel.shared.userSelectedEntity = nil
    }
    
    func randomFrame() async {
                
        let image = UIImage(named: ContentService.images.historical.randomElement()!, in: .main, with: .none)!
        
        await newFrame(image: image)
    }
    
    func replaceImage(image: UIImage, entity: Entity?) async {
        guard let modelEntity = entity as? ModelEntity else { return }
        guard let frameModel = modelEntity.model else { return }
        
        let aspectRatio = frameModel.width() / frameModel.height()

        modelEntity.model = ModelComponent(mesh: frameModel.mesh, materials: [
            imageMaterial(ImageProcessingService.shared.process(image: image, aspectRatio: CGFloat(aspectRatio)).cgImage!),
            UnlitMaterial(),
            ContentService.FrameMaterials.simpleMaterial()
        ])
    }
    
    func newFrame(image: UIImage) async {
        
        let frameURL = Bundle.main.url(forResource: "wood-frame", withExtension: ".usdz")
        guard let frameURL else { return }
        
//            let frameEntity = try ModelEntity.loadModel(contentsOf: frameURL)
        
        var cancellable: AnyCancellable? = nil
        cancellable = ModelEntity.loadModelAsync(contentsOf: frameURL)
            .sink(receiveCompletion: { error in
                print("Error loading frame: \(error)")
                cancellable?.cancel()
            }, receiveValue: { frameEntity in
                
                guard let frameModel = frameEntity.model else { return }
                    
                let aspectRatio = frameModel.width() / frameModel.height()

                frameEntity.model = ModelComponent(mesh: frameModel.mesh, materials: [
                    self.imageMaterial(ImageProcessingService.shared.process(image: image, aspectRatio: CGFloat(aspectRatio)).cgImage!),
                    UnlitMaterial(),
                    ContentService.FrameMaterials.simpleMaterial()
//                    self.frameMaterial()
                ])
                
                if (image.size.width > image.size.height) {
                    let angle = -90 * (Float.pi / 180)
                    let rotationMatrix = float4x4(
                        [cos(angle), 0, -sin(angle), 0],
                        [0, 1, 0, 0],
                        [sin(angle), 0, cos(angle), 0],
                        [0, 0, 0, 1])
                    
                    frameEntity.orientation = simd_quatf(rotationMatrix)
                }
                
                frameEntity.generateCollisionShapes(recursive: true)
            
                self.arView.installGestures([.translation, .scale, .rotation], for: frameEntity)
                
                guard let wallAnchor = self.arView.scene.anchors.first else { return }
                wallAnchor.addChild(frameEntity)
                cancellable?.cancel()
            })
    }
    
//    private func frameMaterial() -> Material {
//        var frameMaterial = SimpleMaterial()
//
//        frameMaterial.color = SimpleMaterial.BaseColor(tint: .blue)
//        frameMaterial.roughness = 0.5
//        frameMaterial.metallic = 0.0
//
//        return frameMaterial
//    }
    
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
        
        return imageMaterial
    }
}
