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

    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            
            HStack(alignment: .center) {
                
                Text("Image Selection")
                    .font(.headline)

                Spacer()
                
                Button {
                    ARViewModel.shared.userSelectedEntity = nil
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
                    .font(.subheadline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(ContentService.images, id: \.self) { image in
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .onTapGesture {
                                    Task {
                                        await ARViewService.shared.replaceImage(image: UIImage(named: image)!, entity: arVM.userSelectedEntity)
                                    }
                                }
                        }
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Abstract")
                    .font(.subheadline)
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
                    .font(.subheadline)
                HStack {
                   Image(systemName: "plus")
                    .font(.system(size: 25))
                    .frame(width: 100, height: 100)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                    Spacer()
                }
            }
            
            Spacer()
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
            .padding()
            
            .frame(height: 600)
            
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            
            .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 20))
            
           
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("iPhone 14")
    }
}
