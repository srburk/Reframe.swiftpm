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
        
        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(sizeLabelPosition: $sizeLabelPosition)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    class Coordinator: NSObject, ARSessionDelegate {
        
        @Binding private var sizeLabelPosition: SIMD3<Float>
        
        init(sizeLabelPosition: Binding<SIMD3<Float>>) {
            self._sizeLabelPosition = sizeLabelPosition
        }
    }
}
