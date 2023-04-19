//
//  PictureSelectionView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/3/23.
//

import SwiftUI
import RealityKit

struct PictureSelectionView: View {
        
    @State private var showingImagePickerView = false
//    @State private var showingCameraPickerView = false

    @State var galleryObject: VirtualGallery.GalleryObject
        
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
            .padding((galleryObject.isSelected) ? [.trailing, .top] : [.trailing])

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
                                    .foregroundColor((UIImage(named: image) == galleryObject.image) ? .gray : Color.clear)
                                Image(image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .onTapGesture {
                                        self.galleryObject.image = UIImage(named: image)!
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
                        ForEach(ContentService.images.abstract, id: \.self) { image in
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .frame(width: 110, height: 110)
                                    .foregroundColor((UIImage(named: image) == galleryObject.image) ? .gray : Color.clear)
                                Image(image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .onTapGesture {
                                        self.galleryObject.image = UIImage(named: image)!
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
                        showingImagePickerView = true
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
            
            if galleryObject.isSelected {
                Button {
                    Task {
                        await VirtualGallery.shared.replaceObject(galleryObject)
                        VirtualGallery.shared.bottomSheetState = .normal
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Apply")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(width: .infinity, height: 50)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 15))
                }
                .buttonStyle(.plain)
                .padding(.trailing)
                .padding(.bottom, 10)
            }
        }
        
        .padding(.leading)
        
        Spacer()
        
        .sheet(isPresented: $showingImagePickerView) {
            ImagePickerComponent(image: $galleryObject.image, sourceType: .photoLibrary)
        }
        
//        .fullScreenCover(isPresented: $showingCameraPickerView, content: {
//            ImagePickerComponent(image: $galleryObject.image, sourceType: .camera)
//                .ignoresSafeArea(.all)
//        })
    }
}

struct PictureSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Spacer()
            
            VStack {
                PictureSelectionView(galleryObject: VirtualGallery.GalleryObject(image: UIImage(), frameColor: .black))
//                PictureSelectionView(gall: .constant(UIImage(named: "MonaLisa")!))
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
