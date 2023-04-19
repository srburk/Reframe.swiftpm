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
import SwiftUI

enum BottomSheetState {
    case normal, pictureSelection, frameSelection, newFrame, collaboration
    
    func bottomSheetHeight() -> CGFloat {
        switch (self) {
            case .normal:
                return 0
            default:
                return 600
        }
    }
}

enum MultipeerState {
    case none, advertising, browsing
}

final class VirtualGallery: ObservableObject {
    
    static let shared = VirtualGallery()
    
    // MARK: Published properties
    @Published var loadingNewObject: Bool = false
    @Published var bottomSheetState: BottomSheetState = .normal
    @Published var isObjectSelected: Bool = false {
        didSet {
            if (!isObjectSelected) {
                self.bottomSheetState = .normal
            }
        }
    }

    // potentially dangerous func...
    public var selectedGalleryObject: GalleryObject {
        return collection.first(where: { $0.isSelected })!
    }
    
    public var realWorldSizeLabel: String {
        if let object = (mainAnchor?.children.first(where: { $0.name == selectedGalleryObject.id.uuidString })) as? ModelEntity, let model = object.model {
            let width = (object.transform.scale.x * Float(model.width()) * 100) / 2.54
            let height = (object.transform.scale.y * Float(model.height()) * 100) / 2.54
            return "\(String(format: "%.2f", width))in × \(String(format: "%.2f", height))in"
        } else {
            return ""
        }
    }
    
    let arView = GalleryView(frame: .zero)
    
    class GalleryObject: ObservableObject {
        
        var id: UUID
        @Published var image: UIImage
        @Published var frameName: String
        @Published var frameColor: Color
        @Published var matteSize: CGFloat // between 0 and 1
        
        @Published var isSelected: Bool = false
        
        init(image: UIImage, frameURL: String = ContentService.frames.first!.key, matteSize: CGFloat = 0.2, frameColor: Color) {
            self.id = UUID()
            self.image = image
            self.frameName = frameURL
            self.matteSize = matteSize
            self.frameColor = frameColor
        }
    }
    
    func captureScreen() {
        
        let whiteUIView = UIView(frame: arView.bounds)
        whiteUIView.backgroundColor = .init(white: 1.0, alpha: 1.0)
        arView.addSubview(whiteUIView)
        arView.snapshot(saveToHDR: false) { image in
            guard (image != nil) else { return }
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        Task {
            try await Task.sleep(nanoseconds: UInt64(0.35 * Double(NSEC_PER_SEC)))
            if let whiteView = await arView.subviews.last {
                await whiteView.removeFromSuperview()
            }
        }
    }
    
    public var collection: [GalleryObject] = []
        
    private var mainAnchor: AnchorEntity? {
        return arView.scene.anchors.first as? AnchorEntity
    }

    private func imageMaterial(_ image: UIImage, aspectRatio: CGFloat, matteSize: CGFloat = 0.2) -> RealityKit.Material {
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
        guard !collection.isEmpty else { return }
        print("Virtual Gallery Collection:")
        self.collection.forEach { object in
            print("\t \(object.id)")
            print("\t\t Frame Name: \(object.frameName)")
            print("\t\t Frame Color: \(object.frameColor.description)")
            print("\t\t Image: \(object.image.description)")
            print("\t\t Matte Size: \(object.matteSize)")
            print("\t\t \((object.isSelected) ? "SELECTED" : "NOT SELECTED")")
        }
    }
    
    @MainActor
    public func replaceObject(_ object: GalleryObject) async {
        guard let objectToRemove = (mainAnchor?.children.first(where: { $0.name == object.id.uuidString })) else { return }
        
        self.loadingNewObject = true
        
        var cancellable: AnyCancellable? = nil
        cancellable = ModelEntity.loadModelAsync(contentsOf: ContentService.frames[object.frameName]!)
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
                        SimpleMaterial(color: UIColor(object.frameColor), roughness: 0.5, isMetallic: false)
                    ])
                    
                    guard let mainAnchor = self.mainAnchor else { return}
                    
                    frameEntity.name = object.id.uuidString
                    frameEntity.generateCollisionShapes(recursive: true)
                    self.arView.installGestures([.translation, .rotation, .scale], for: frameEntity)
                    
                    frameEntity.position = objectToRemove.position
                    frameEntity.transform = objectToRemove.transform
                    
                    mainAnchor.removeChild(objectToRemove)
                    
                    mainAnchor.addChild(frameEntity)
                    
                    //MARK: Debug
//                    print("Successfully loaded object")
//                    self.debugReport()
                    
                    self.loadingNewObject = false
                }
                cancellable?.cancel()
            })
    }
    
    @MainActor
    public func addObject(_ object: GalleryObject) async {
        
        self.loadingNewObject = true
        
        var cancellable: AnyCancellable? = nil
        cancellable = ModelEntity.loadModelAsync(contentsOf: ContentService.frames[object.frameName]!)
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
                        SimpleMaterial(color: UIColor(object.frameColor), roughness: 0.5, isMetallic: false)
                    ])
                    
                    guard let mainAnchor = self.mainAnchor else { return}
                    
                    frameEntity.name = object.id.uuidString
                    frameEntity.generateCollisionShapes(recursive: true)
                    self.arView.installGestures([.translation, .rotation, .scale], for: frameEntity)
                    
                    mainAnchor.addChild(frameEntity)
                    
                    self.collection.append(object)
                    
                    //MARK: Debug
//                    print("Successfully added object")
//                    self.debugReport()
                    
                    self.loadingNewObject = false
                }
                cancellable?.cancel()
            })
    }
    
    public func removeObject(_ object: GalleryObject) {
        guard let mainAnchor = self.mainAnchor else { return }
        guard let objectToRemove = mainAnchor.children.first(where: { $0.name == object.id.uuidString }) else { return }
        mainAnchor.removeChild(objectToRemove)
        collection.removeAll(where: { $0.id == object.id })
        
        self.isObjectSelected = false
        self.bottomSheetState = .normal
        
        //MARK: Debug
//        print("Successfully removed object")
//        self.debugReport()
    }
}
