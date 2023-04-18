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

    @Binding var inputImage: UIImage?
        
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            
            HStack(alignment: .center) {

                Text("Image")
                    .font(.system(size: 20, weight: .bold))

                Spacer()
                
                Button {
//                    arVM.bottomSheetState = .userSelection
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
                                    .foregroundColor((UIImage(named: image) == inputImage) ? .gray : Color.clear)
                                Image(image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .onTapGesture {
                                        self.inputImage = UIImage(named: image)
                                    }
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

//                    ForEach(ContentService.images.custom, id: \.self) { imageName in
//                        Image(uiImage: ContentService.images.customImage(imageName))
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 100, height: 100)
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                            .onTapGesture {
//
//                    }
                    
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
        
//        .onChange(of: inputImage) { _ in
//            loadCustomImage()
//        }
    }
}

struct PictureSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Spacer()
            
            VStack {
                PictureSelectionView(inputImage: .constant(UIImage(named: "MonaLisa")))
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
