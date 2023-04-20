//
//  NewFrameView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/17/23.
//

import SwiftUI

struct NewFrameView: View {
    
    private enum NewFrameCreationStage {
        case image, frame
    }
    
    @ObservedObject var virtualGallery = VirtualGallery.shared

    @State private var newFrameCreationStage: NewFrameCreationStage = .image
    @ObservedObject var newGalleryObject = VirtualGallery.GalleryObject(image: UIImage(), frameColor: .black)
    
    func finishCreation() {
        
        Task {
            await VirtualGallery.shared.addObject(newGalleryObject)
        }
                
        virtualGallery.bottomSheetState = .normal
    }
    
    var body: some View {
        
        VStack() {
            
            switch (newFrameCreationStage) {
                case NewFrameCreationStage.image:
                    PictureSelectionView(image: $newGalleryObject.image)
                case NewFrameCreationStage.frame:
//                    EmptyView()
                    FrameSelectionView(galleryObject: newGalleryObject)
//                    FrameSelectionView(frame: $vm.frame, mattePercentage: $vm.matteSize, frameColor: $vm.frameColor)
            }
            
            Spacer()
            
            HStack {
                if (newFrameCreationStage == .frame) {
                    Button {
                        newFrameCreationStage = .image
                    } label: {
                        Label("Back", systemImage: "arrow.left")
                    }
                }
                
                Spacer()
                
                Button {
                    if (newFrameCreationStage == .image) {
                        newFrameCreationStage = .frame
                    } else {
                        finishCreation()
                    }
                } label: {
                    Text("\((newFrameCreationStage == .image) ? "Next" : "Add")")
                }
            }
            .padding([.trailing, .leading], 25)
            .padding(.bottom, 30)
        }
    }
}

struct NewFrameView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Spacer()
            
            VStack {
                NewFrameView()
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
