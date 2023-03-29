//
//  ARViewOverlay.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import Foundation
import SwiftUI

struct ARViewOverlay: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Button {
                    // MARK: Take picture
                    print("Picture!")
                } label: {
                    Image(systemName: "camera.shutter.button")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                        .padding(20)
                }
                .background(.regularMaterial)
                .clipShape(Circle())

                Spacer()
            }
            .padding(.top, 50)
            .padding(.leading, 10)
            
            Spacer()
            
            HStack() {
                
                VStack {
                    Text("This is a sheet")
                }
                .frame(height: 150)
                .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 25))
                .padding(.bottom, (UIDevice.current.userInterfaceIdiom == .pad) ? 25 : 0)
                .padding(.leading, (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 0)
            }
        }
    }
}

struct ARViewOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.cyan
            ARViewOverlay()
        }
        .edgesIgnoringSafeArea(.all)
        
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("iPhone 14")
        
        ZStack {
            Color.cyan
            ARViewOverlay()
        }
        .edgesIgnoringSafeArea(.all)
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
        .previewDisplayName("iPad Pro 12.9-inch")
    }
}
