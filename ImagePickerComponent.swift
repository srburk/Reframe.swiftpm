//
//  ImagePickerView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/16/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePickerComponent: UIViewControllerRepresentable {
        
    @Binding var image: UIImage
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: ImagePickerComponent
        
        init(picker: ImagePickerComponent) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.picker.image = selectedImage
            if let data = self.picker.image.pngData() {
                do {
                    let imageID = UUID()
                    guard let fileURL = ContentService.documentDirectory()?.appendingPathComponent("\(imageID.uuidString).png") else { return }
                    try data.write(to: fileURL)
                } catch {
                    print(error)
                }
            }
            self.picker.isPresented.wrappedValue.dismiss()
        }
        
    }
}
