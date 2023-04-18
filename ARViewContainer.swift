//
//  ARViewContainer.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit
import UIKit

struct ARViewContainer : UIViewRepresentable {
    
    @State private var sizeLabelPosition: SIMD3<Float> = .zero
                
    func makeUIView(context: Context) -> UIView {
        
        let arView = VirtualGallery.shared.arView
        
        let coachingOverlay = ARCoachingOverlayView(frame: arView.frame)
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(coachingOverlay)
        coachingOverlay.setActive(true, animated: true)
        coachingOverlay.topAnchor.constraint(equalTo: arView.topAnchor).isActive = true
        coachingOverlay.leadingAnchor.constraint(equalTo: arView.leadingAnchor).isActive = true
        coachingOverlay.trailingAnchor.constraint(equalTo: arView.trailingAnchor).isActive = true
        coachingOverlay.bottomAnchor.constraint(equalTo: arView.bottomAnchor).isActive = true
        coachingOverlay.goal = .verticalPlane
        coachingOverlay.session = arView.session
        
        arView.session.delegate = context.coordinator
        
//        arView.renderCallbacks.postProcess = postProcessCallback

        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(sizeLabelPosition: $sizeLabelPosition)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
                        
//            if let projectedPoint = uiView.project(sizeLabelPosition) {
//
//                print("Projected Point \(projectedPoint.x), \(projectedPoint.y)")
//
//                let shapeLayer = CAShapeLayer()
//                let path = CGMutablePath()
//                let rect = CGRect(x: projectedPoint.x, y: projectedPoint.y, width: 5, height: 5)
//                path.addEllipse(in: rect)
//
//                shapeLayer.fillColor = UIColor(.white).cgColor
//                shapeLayer.path = path
//                shapeLayer.name = "PointCloudLayer"
//
//                if let oldLayer = uiView.layer.sublayers?.first(where: { $0.name == "PointCloudLayer" }) {
//                    uiView.layer.replaceSublayer(oldLayer, with: shapeLayer)
//                    print("Replacing old layer")
//                } else {
//                    uiView.layer.addSublayer(shapeLayer)
//                    print("Adding new layer")
//                }
//            }
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        
        @Binding private var sizeLabelPosition: SIMD3<Float>
        
        init(sizeLabelPosition: Binding<SIMD3<Float>>) {
            self._sizeLabelPosition = sizeLabelPosition
        }
        
//        func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
//            ARViewModel.shared.cameraTrackingState = camera.trackingState
//        }
        
//        func session(_ session: ARSession, didUpdate frame: ARFrame) {
//            guard let selectedEntity = ARViewModel.shared.userSelectedEntity else { return }
//            sizeLabelPosition = selectedEntity.position(relativeTo: nil)
//        }
    }
    
//    private func postProcessCallback(context: ARView.PostProcessContext) {
//
//        if var ciImage = CIImage(mtlTexture: context.sourceColorTexture) {
//
//            if let selectedEntity = ARViewModel.shared.userSelectedEntity {
//
//                let ciContext = CIContext(mtlDevice: context.device)
//                let testImage = CIImage(color: .white)
//
//                ciImage = testImage.composited(over: ciImage)
//
//                ciContext.render(ciImage, to: context.targetColorTexture, commandBuffer: context.commandBuffer, bounds: CGRect(x: 0, y: 0, width: Int(ciImage.extent.width), height: Int(ciImage.extent.height)), colorSpace: ciImage.colorSpace ?? CGColorSpaceCreateDeviceRGB())
//
//                return
//            }
//
//
//            let cmdEncoder = context.commandBuffer.makeBlitCommandEncoder()
//            cmdEncoder?.copy(from: context.sourceColorTexture, to: context.targetColorTexture)
//            cmdEncoder?.endEncoding()
//        }
//    }
}
