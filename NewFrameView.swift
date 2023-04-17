//
//  NewFrameView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/17/23.
//

import SwiftUI

struct NewFrameView: View {
    
    enum PanelSelectionMode: Hashable {
        case image, frame
    }
    
    @ObservedObject var arVM: ARViewModel = ARViewModel.shared
    
    @State private var panelSelectionMode = PanelSelectionMode.image
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            PictureSelectionView()
            
//            Picker("", selection: $panelSelectionMode) {
//                ForEach(PanelSelectionMode.allTypes)
//            }
//            .pickerStyle(.segmented)
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
