//
//  Extensions.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/4/23.
//

import RealityKit
import SwiftUI
import ARKit

extension ModelComponent {
    func width() -> CGFloat {
        return CGFloat(self.mesh.bounds.max.x - self.mesh.bounds.min.x)
    }
    func height() -> CGFloat {
        return CGFloat(self.mesh.bounds.max.z - self.mesh.bounds.min.z)
    }
}

extension Color {
    public static let lightGray = Color(red: 236/255, green: 236/255, blue: 237/255)
    public static let buttonGray = Color(red: 213/255, green: 213/255, blue: 213/255)
}

extension View {

    func prefersPersistentSystemOverlaysHidden() -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return self.persistentSystemOverlays(.hidden)
        } else {
            return self
        }
    }
}
