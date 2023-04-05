//
//  ARViewModel.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/4/23.
//

import Foundation
import ARKit

final class ARViewModel: ObservableObject {
    
    @Published var cameraTrackingState: ARCamera.TrackingState = .notAvailable
    
}
