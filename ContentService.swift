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
            "GirlWithAPearlEarring",
            "TheLastSupper",
            "TheScream"
        ]
        static var contemporary = [
            "QuatreEspacesACroixBrisee"
        ]
        static var custom: [String] {
            guard let documentsDirectory = ContentService.documentDirectory() else { return [] }
            let contents = try? FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            guard let contents else { return [] }
            return contents.map { url in
                url.lastPathComponent
            }
        }
    }
    
    // MARK: Display name : Internal Name
    static var frames: [String: URL] = [
        "Wood": Bundle.main.url(forResource: "wood-frame", withExtension: ".usdz")!,
        "Simple Plastic" : Bundle.main.url(forResource: "simple-plastic", withExtension: ".usdz")!,
        "Elaborate" : Bundle.main.url(forResource: "elaborate", withExtension: ".usdz")!
    ]
    
    static func documentDirectory() -> URL? {
        return try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}
