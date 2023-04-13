//
//  Extensions.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/4/23.
//

import RealityKit
import SwiftUI

extension ModelComponent {
    func width() -> Float {
        return self.mesh.bounds.max.x - self.mesh.bounds.min.x
    }
    func height() -> Float {
        return self.mesh.bounds.max.z - self.mesh.bounds.min.z
    }
}

extension Color {
    public static let lightGray = Color(red: 236/255, green: 236/255, blue: 237/255)
}
