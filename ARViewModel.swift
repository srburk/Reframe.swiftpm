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
    case none, pictureSelection, userSelection, frameSelection, newFrame
    
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
    
    let arView = GalleryView(frame: .zero)
    
    func captureScreen() {
        arView.snapshot(saveToHDR: false) { image in
            guard (image != nil) else { return }
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }
    
//    @Published var cameraTrackingState: ARCamera.TrackingState = .notAvailable
    
    @Published var userSelectedObject: VirtualGallery.GalleryObject? {
        didSet(newValue) {
            if let userSelectedObject {
                bottomSheetState = .userSelection
                if newValue?.id == userSelectedObject.id {
                    if newValue != userSelectedObject {
                        Task {
                            await VirtualGallery.shared.replaceObject(userSelectedObject)
                        }
                    }
                }
            } else {
                bottomSheetState = .none
            }
//            bottomSheetState = (userSelectedObject != nil) ? .userSelection : .none
        }
    }

    @Published var loadingNewObject: Bool = false
    
    @Published private(set) var bottomSheetHeight: CGFloat = 0
    
    @Published var bottomSheetState: BottomSheetState = .none {
        didSet {
            withAnimation {
                bottomSheetHeight = bottomSheetState.bottomSheetHeight()
            }
        }
    }
}
