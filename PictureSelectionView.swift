//
//  PictureSelectionView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/3/23.
//

import SwiftUI
import RealityKit

struct PictureSelectionView: View {
    
    @ObservedObject var arVM: ARViewModel = ARViewModel.shared
    
    @State private var showingImagePickerView = false
    @State private var showingCameraPickerView = false

    @State private var inputImage: UIImage?
        
    private func loadCustomImage() {
        guard let inputImage else { return }
//        Task {
//            await ARViewService.shared.replaceImage(image: inputImage, entity: arVM.userSelectedEntity)
//        }
    }

    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            
            HStack(alignment: .center) {

                Text("Image")
                    .font(.system(size: 20, weight: .bold))

                Spacer()
                
                Button {
                    arVM.bottomSheetState = .userSelection
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
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .onTapGesture {
//                                    Task {
//                                        await ARViewService.shared.replaceImage(image: UIImage(named: image)!, entity: arVM.userSelectedEntity)
//                                    }
                                }
                        }
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Abstract")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<5) { _ in
                            Image("MonaLisa")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Custom")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                
                HStack {
                    Menu {
                        
                        Button {
                            showingCameraPickerView = true
                        } label: {
                            Label("Take Photo", systemImage: "camera")
                        }
                        
                        Button {
                            showingImagePickerView = true
                        } label: {
                            Label("Photo Library", systemImage: "photo.on.rectangle")
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

                    ForEach(ContentService.images.custom, id: \.self) { imageName in
                        Image(uiImage: ContentService.images.customImage(imageName))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .onTapGesture {
//                                Task {
//                                    await ARViewService.shared.replaceImage(image: UIImage(contentsOfFile: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(imageName).png").absoluteString)!, entity: arVM.userSelectedEntity)
//                                }
                            }
                    }
                    
                    Spacer()
                }
            }
        }
        
        .padding(.leading)
        
        Spacer()
        
        .sheet(isPresented: $showingImagePickerView) {
            ImagePickerComponent(image: $inputImage, sourceType: .photoLibrary)
        }
        
        .fullScreenCover(isPresented: $showingCameraPickerView, content: {
            ImagePickerComponent(image: $inputImage, sourceType: .camera)
                .ignoresSafeArea(.all)
        })
        
        .onChange(of: inputImage) { _ in
            loadCustomImage()
        }
    }
}

struct PictureSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Spacer()
            
            VStack {
                PictureSelectionView()
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
