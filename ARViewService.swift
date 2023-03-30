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
}
