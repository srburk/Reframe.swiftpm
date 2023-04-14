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

enum BottomSheetState {
    case none, pictureSelection, userSelection
    
    func bottomSheetHeight() -> CGFloat {
        switch (self) {
            case .none:
                return 0
            case .userSelection:
                return 200
            default:
                return 600
        }
    }
}

final class ARViewModel: ObservableObject {
    
    public static var shared = ARViewModel()
    
//    @Published var cameraTrackingState: ARCamera.TrackingState = .notAvailable
    
    @Published var userSelectedEntity: Entity? {
        didSet {
            if userSelectedEntity != nil {
                bottomSheetState = .userSelection
            } else {
                bottomSheetState = .none
            }
        }
    }
    
    @Published var bottomSheetHeight: CGFloat = 0
    
    @Published var bottomSheetState: BottomSheetState = .none {
        didSet {
//            if (bottomSheetState != .none) {
//                Task {
//                    await ARViewService.shared.arView.session.pause()
//                }
//            } else {
//                Task {
//                    await ARViewService.shared.arView.session.run(GalleryView.defaultSessionConfig)
//                }
//            }
            withAnimation {
                bottomSheetHeight = bottomSheetState.bottomSheetHeight()
            }
        }
    }
    
}
