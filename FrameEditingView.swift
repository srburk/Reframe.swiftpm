//
//  FrameEditingView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/15/23.
//

import Foundation
import SwiftUI

struct FrameEditingView: View {
    
    @ViewBuilder
    private func arEditingButton(systemName: String, bottomSheetMode: BottomSheetState) -> some View {
        
        Button {
            ARViewModel.shared.bottomSheetState = bottomSheetMode
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray)
                    .foregroundColor(.clear)
                
                Image(systemName: systemName)
                    .font(.system(size: 35))
                    .foregroundColor(.primary)
            }
        }
    }
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                
                Text("Options – \((ARViewModel.shared.userSelectedEntity != nil) ? "Selected" : "N/A")")
                    .font(.headline)
                
                Menu {
                    Text("Option 1")
                    Text("Option 2")
                } label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .foregroundColor(.gray)
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                }

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
            HStack(alignment: .center, spacing: 20) {
                arEditingButton(systemName: "photo", bottomSheetMode: .pictureSelection)
                arEditingButton(systemName: "photo.artframe", bottomSheetMode: .pictureSelection)
                arEditingButton(systemName: "square.inset.filled", bottomSheetMode: .pictureSelection)
            }
            
            Spacer()
        }
        .padding(.trailing)
    }
}
