//
//  VirtualGallery.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/17/23.
//

import Foundation
import Combine
import UIKit
import RealityKit

final class VirtualGallery: ObservableObject {
    
    static let shared = VirtualGallery()
    
    struct GalleryObject {
        var id: UUID
        var image: UIImage
        var frameURL: URL
        var matteSize: CGFloat // between 0 and 1
        var postion: SIMD3<Float>
        
        init(image: UIImage, frameURL: URL, matteSize: CGFloat, position: SIMD3<Float> = .zero) {
            self.id = UUID()
            self.image = image
            self.frameURL = frameURL
            self.matteSize = matteSize
            self.postion = position
        }
    }
    
    @Published private(set) var collection: [GalleryObject] = []
    
    private let arView = ARViewService.shared.arView
    
    private var mainAnchor: AnchorEntity? {
        return arView.scene.anchors.first as? AnchorEntity
    }
    
    private func imageMaterial(_ image: UIImage, aspectRatio: CGFloat, matteSize: CGFloat = 0.2) -> Material {
        var imageMaterial = SimpleMaterial()
                
            if let textureImage = ImageService.processForTexture(image: image, aspectRatio: aspectRatio, matteSize: matteSize) {
                do {
                    let texture = try TextureResource.generate(from: textureImage, options: .init(semantic: .color))
                    imageMaterial.color = SimpleMaterial.BaseColor(tint: .white, texture: MaterialParameters.Texture(texture))
                } catch {
                    print("Error converting image to material texture")
                }
            }
        return imageMaterial
    }
    
}

extension VirtualGallery {
    
    public func debugReport() {
        print("Virtual Gallery Collection:")
        self.collection.forEach { object in
            print("\t \(object.id)")
        }
    }
    
    @MainActor
    public func addObject(_ object: GalleryObject) async {
        
        ARViewModel.shared.loadingNewObject = true
        
        var cancellable: AnyCancellable? = nil
        cancellable = ModelEntity.loadModelAsync(contentsOf: object.frameURL)
            .sink(receiveCompletion: { error in
                print("Error loading frame mode: \(error)")
                cancellable?.cancel()
            }, receiveValue: { frameEntity in
                Task {
                    guard let frameModel = frameEntity.model else { return }
                    let aspectRatio = frameModel.width() / frameModel.height()
                    
                    frameEntity.model = ModelComponent(mesh: frameModel.mesh, materials: [
                        self.imageMaterial(object.image, aspectRatio: aspectRatio, matteSize: object.matteSize),
                        UnlitMaterial(),
                        ContentService.FrameMaterials.simpleMaterial()
                    ])
                    
                    guard let mainAnchor = self.mainAnchor else { return}
                    
                    frameEntity.name = object.id.uuidString
                    frameEntity.generateCollisionShapes(recursive: true)
                    self.arView.installGestures([.translation, .rotation, .scale], for: frameEntity)
                    
                    mainAnchor.addChild(frameEntity)
                    
                    self.collection.append(object)
                    print("Successfully added object")
                    ARViewModel.shared.loadingNewObject = false
                }
                cancellable?.cancel()
            })
    }
    
    public func removeObject(_ object: GalleryObject) {
        guard let mainAnchor = self.mainAnchor else { return }
        guard let objectToRemove = mainAnchor.children.first(where: { $0.name == object.id.uuidString }) else { return }
        mainAnchor.removeChild(objectToRemove)
        collection.removeAll(where: { $0.id == object.id })
        print("Successfully removed object")
    }
}
