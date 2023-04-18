//
//  FrameSelectionView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/16/23.
//

import SwiftUI

struct FrameSelectionView: View {
    
    @ObservedObject var arVM: ARViewModel = ARViewModel.shared
    
    @Binding var frame: String
    @Binding var mattePercentage: CGFloat
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            HStack(alignment: .center) {
                
                Text("Frame")
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
                HStack {
                    Text("Frames")
                        .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                    Spacer()
                }
                
                HStack {
                    Text("Select a frame")
                    Spacer()
                    Picker("Frame", selection: $frame) {
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
                Text("Materials")
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
                HStack {
                    Text("Matte Size")
                        .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                    Spacer()
                }
                Slider(value: $mattePercentage, in: 0...1) {
                    
                } minimumValueLabel: {
                    Image(systemName: "minus")
                } maximumValueLabel: {
                    Image(systemName: "plus")
                }
            }
            .padding(.trailing)
            
            Spacer()
        }
        .padding([.leading])
    }
}

struct FrameSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Spacer()
            
            VStack {
                FrameSelectionView(frame: .constant("Wood"), mattePercentage: .constant(0.2))
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
