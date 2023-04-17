//
//  ARViewModel.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/4/23.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI
import PhotosUI

enum BottomSheetState {
    case none, pictureSelection, userSelection, frameSelection
    
    func bottomSheetHeight() -> CGFloat {
        switch (self) {
            case .none:
                return 0
            case .userSelection:
                return 0
            default:
                return 600
        }
    }
}

final class ARViewModel: ObservableObject {
    
    public static var shared = ARViewModel()
    
    @Published var cameraTrackingState: ARCamera.TrackingState = .notAvailable
    
    @Published var userSelectedEntity: Entity? {

        didSet {
            bottomSheetState = (userSelectedEntity != nil) ? .userSelection : .none
        }
    }
    
    @Published private(set) var bottomSheetHeight: CGFloat = 0
    
    @Published var bottomSheetState: BottomSheetState = .none {
        didSet {
            withAnimation {
                bottomSheetHeight = bottomSheetState.bottomSheetHeight()
            }
        }
    }
}
