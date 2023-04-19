//
//  FrameSelectionView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/16/23.
//

import SwiftUI

struct FrameSelectionView: View {
    
//    @ObservedObject var arVM: ARViewModel = ARViewModel.shared
    
//    @Binding var frame: String
//    @Binding var mattePercentage: CGFloat
//    @Binding var frameColor: Color
    
    @State var galleryObject: VirtualGallery.GalleryObject
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            HStack(alignment: .center) {
                
                Text("Frame")
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
            .padding([.trailing])
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Frames")
                        .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                    Spacer()
                }
                
                HStack {
                    Text("Select a frame")
                    Spacer()
                    Picker("Frame", selection: $galleryObject.frameName) {
                        ForEach(Array(ContentService.frames.keys), id: \.self) { key in
                            Text(key)
                        }
                    }
                    .background(Color.buttonGray, in: RoundedRectangle(cornerRadius: 15))
                    .tint(.primary)
                    .pickerStyle(.menu)
                }
                .padding(.trailing, 10)
                
            }
            
            VStack(alignment: .leading) {
                Text("Frame Color")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                
                HStack {
                    ColorPicker(selection: $galleryObject.frameColor, supportsOpacity: false, label: {
                        Text("Select a color")
                    })
                }
                .padding(.trailing, 10)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Matte Size")
                        .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                    Spacer()
                }
                Slider(value: $galleryObject.matteSize, in: 0...1) {
                    
                } minimumValueLabel: {
                    Image(systemName: "minus")
                } maximumValueLabel: {
                    Image(systemName: "plus")
                }
            }
            .padding(.trailing)
            
            Spacer()
            
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
        .padding([.leading])
    }
}

struct FrameSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Spacer()
            
            VStack {
                FrameSelectionView(galleryObject: VirtualGallery.GalleryObject(image: UIImage(), frameColor: .blue))
//                FrameSelectionView(frame: .constant("Wood"), mattePercentage: .constant(0.2), frameColor: .constant(.black))
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
