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
        
//    private class NewFrameViewModel: ObservableObject {
//
//        @Published var image: UIImage = UIImage()
//        @Published var frame: String = ContentService.frames.first!.key
//        @Published var frameColor: Color = .black
//        @Published var matteSize: CGFloat = 0.2
//
//        @Published var newFrameCreationStage: NewFrameCreationStage = .image
//
//    }
    
    @ObservedObject var arVM: ARViewModel = ARViewModel.shared
//    @ObservedObject private var vm = NewFrameViewModel()
    
    @State private var newFrameCreationStage: NewFrameCreationStage = .image
    @State var newGalleryObject = VirtualGallery.GalleryObject(image: UIImage(), frameColor: .black)
    
    func finishCreation() {
        
//        guard let image = vm.image else { return }
//        guard let frameURL = ContentService.frames[vm.frame] else { return }
        
//        let newObject = VirtualGallery.GalleryObject(image: vm.image, frameURL: frameURL, matteSize: vm.matteSize, frameColor: UIColor(vm.frameColor))
        
        Task {
            await VirtualGallery.shared.addObject(newGalleryObject)
        }
                
        arVM.bottomSheetState = .none
    }
    
    var body: some View {
        
        VStack() {
            
            switch (newFrameCreationStage) {
                case NewFrameCreationStage.image:
                    PictureSelectionView(galleryObject: $newGalleryObject)
                case NewFrameCreationStage.frame:
//                    EmptyView()
                    FrameSelectionView(galleryObject: $newGalleryObject)
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
//                .disabled(vm.image == nil)
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
