//
//  PictureSelectionView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/3/23.
//

import SwiftUI

struct PictureSelectionView: View {
    var body: some View {
        NavigationView {
            
            // MARK: Change this to a grid later
            VStack {
                HStack {
                    
                    NavigationLink {
                        Text("Hello World")
                    } label: {
                        Image("MonaLisa", bundle: .main)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding()
                    }
                    
                    Image("GirlWithAPearlEarring", bundle: .main)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                }
                Spacer()
            }
            .navigationTitle("Picture Selection")
            .navigationViewStyle(.stack)
        }
    }
}

struct PictureSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PictureSelectionView()
    }
}
