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
        
    func makeUIView(context: Context) -> GalleryView {
        
        let arView = ARViewService.shared.arView
                        
        return arView
    }
    
    func updateUIView(_ uiView: GalleryView, context: Context) {
        
    }
}
