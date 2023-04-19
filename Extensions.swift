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
    public static let lightGray = Color("LightGray")
    public static let buttonGray = Color("ButtonGray")
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

extension Binding {
    func optionalBinding<T>() -> Binding<T>? where T? == Value {
        if let wrappedValue = wrappedValue {
            return Binding<T>(
                get: { wrappedValue },
                set: { self.wrappedValue = $0 }
            )
        } else {
            return nil
        }
    }
}
