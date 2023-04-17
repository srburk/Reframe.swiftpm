//
//  MatteSelectionView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/16/23.
//

import SwiftUI

struct MatteSelectionView: View {
    
    @ObservedObject var arVM: ARViewModel = ARViewModel.shared
    
    @State var mattePercentage: Float = 0.8
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            HStack(alignment: .center) {
                
                Text("Matte")
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
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Size")
                        .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray)
                    Spacer()
                }
                
                Slider(value: $mattePercentage, in: 0...10)
                
            }
            
            Spacer()
            
            Button {
                // generate
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
        }
        .padding([.trailing, .leading, .top])
        .padding(.bottom, 25)
    }
}

struct MatteSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Spacer()
            
            VStack {
                MatteSelectionView()
            }
            .padding(.top)
            
            .frame(height: 250)
            
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            
            .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 20))
            
           
        }
        .edgesIgnoringSafeArea(.all)
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("iPhone 14")
    }
}
