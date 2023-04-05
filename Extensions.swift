//
//  Extensions.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/4/23.
//

import RealityKit

extension ModelComponent {
    func width() -> Float {
        return self.mesh.bounds.max.x - self.mesh.bounds.min.x
    }
    func height() -> Float {
        return self.mesh.bounds.max.z - self.mesh.bounds.min.z
    }
}
