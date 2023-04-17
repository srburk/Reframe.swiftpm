//
//  ContentService.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/15/23.
//

import Foundation
import RealityKit
import UIKit

final class ContentService {
    
    struct images {
        static var historical = [
            "MonaLisa",
            "StarryNight",
            "GirlWithAPearlEarring"
        ]
        static var custom: [String] {
            guard let documentsDirectory = ContentService.documentDirectory() else { return [] }
            let contents = try? FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            guard let contents else { return [] }
            return contents.map { url in
                url.lastPathComponent
            }
        }
        
        static func customImage(_ name: String) -> UIImage {
            var image = UIImage()
            
            guard let imageURL = ContentService.documentDirectory()?.appendingPathComponent("\(name).png") else { return image }
            
            print("URL is: \(imageURL) | Existance: \(FileManager.default.fileExists(atPath: imageURL.absoluteString))")
            
            image = UIImage(contentsOfFile: imageURL.absoluteString) ?? UIImage()
            
            return image
        }
    }
    
    // MARK: Display name : Internal Name
    static var frames: [String: String] = [
        "Wood": "wood-frame",
        "Simple Plastic" : "simple-plastic"
    ]
    
    static var frameMaterials = [
        SimpleMaterial(color: .black, isMetallic: false)
    ]
    
    struct FrameMaterials {
        static func simpleMaterial() -> Material {
            return SimpleMaterial(color: .black, isMetallic: false)
        }
    }
    
    static func documentDirectory() -> URL? {
        return try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}
