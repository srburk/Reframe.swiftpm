//
//  ContentService.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/15/23.
//

import Foundation
import RealityKit

final class ContentService {
    
    static var images = [
        "MonaLisa",
        "StarryNight",
        "GirlWithAPearlEarring"
    ]
    
    // MARK: Display name : Internal Name
    static var frames: [String: String] = [
        "Wood": "wood-frame"
    ]
    
    static var frameMaterials = [
        SimpleMaterial(color: .black, isMetallic: false)
    ]
    
    struct FrameMaterials {
        static func simpleMaterial() -> Material {
            return SimpleMaterial(color: .black, isMetallic: false)
        }
    }
}
