//
//  PictureSelectionView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/3/23.
//

import SwiftUI
import RealityKit
import PhotosUI

struct PictureSelectionView: View {
        
    @State private var showingImagePickerView = false
    
    @Binding var image: UIImage {
        didSet {
            if (VirtualGallery.shared.bottomSheetState == .pictureSelection) {
                Task {
                    await VirtualGallery.shared.replaceObject(VirtualGallery.shared.selectedGalleryObject)
                }
            }
        }
    }
        
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            
            HStack(alignment: .center) {

                Text("Image")
                    .font(.system(size: 20, weight: .bold))

                Spacer()
                
                Button {
                    VirtualGallery.shared.bottomSheetState = .normal
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                        .font(.title)
                }
            }
            .padding(.trailing)

            VStack(alignment: .leading) {
                Text("Historical")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(ContentService.images.historical, id: \.self) { image in
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .frame(width: 110, height: 110)
                                    .foregroundColor((UIImage(named: image) == self.image) ? .accentColor : Color.clear)
                                Image(image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .onTapGesture {
                                        self.image = UIImage(named: image)!
                                    }
                            }
                        }
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Contemporary")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(ContentService.images.contemporary, id: \.self) { image in
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .frame(width: 110, height: 110)
                                    .foregroundColor((UIImage(named: image) == self.image) ? .accentColor : Color.clear)
                                Image(image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .onTapGesture {
                                        self.image = UIImage(named: image)!
                                    }
                            }
                        }
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Custom")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                
                HStack {
                    
                    Button {
                        Task {
                            showingImagePickerView = true
                        }
                    } label: {
                        Image(systemName: "plus")
                         .font(.system(size: 25))
                         .foregroundColor(.gray)
                         .frame(width: 100, height: 100)
                         .background(.ultraThickMaterial)
                         .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
            }
        }
        
        .padding(.leading)
        
        Spacer()
        
        .sheet(isPresented: $showingImagePickerView) {
            ImagePickerComponent(image: $image)
        }
    }
}

struct ImagePickerComponent: UIViewControllerRepresentable {
        
    @Binding var image: UIImage
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

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
            self.picker.isPresented.wrappedValue.dismiss()
        }
        
    }
}

struct PictureSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Spacer()
            
            VStack {
                PictureSelectionView(image: .constant(UIImage(named: "MonaLisa")!))
            }
            .padding(.top)
            
            .frame(height: 600)
            
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            
            .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 20))
            
           
        }
        .edgesIgnoringSafeArea(.all)
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("iPhone 14")
    }
}
