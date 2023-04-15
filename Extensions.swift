//
//  Extensions.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/4/23.
//

import RealityKit
import SwiftUI
import Combine

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

enum AsyncError: Error {
    case finishedWithoutValue
}

extension AnyPublisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var finishedWithoutValue = true
            cancellable = first()
                .sink { result in
                    switch result {
                    case .finished:
                        if finishedWithoutValue {
                            continuation.resume(throwing: AsyncError.finishedWithoutValue)
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    finishedWithoutValue = false
                    continuation.resume(with: .success(value))
                }
        }
    }
}
