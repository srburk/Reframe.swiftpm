//
//  ARViewModel.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/4/23.
//

import Foundation
import ARKit
import RealityKit

final class ARViewModel: ObservableObject {
    
    public static var shared = ARViewModel()
    
    @Published var cameraTrackingState: ARCamera.TrackingState = .notAvailable
    
    @Published var userSelectedEntity: Entity? {
        didSet {
            print("Changed entity setting")
        }
    }
    
}
