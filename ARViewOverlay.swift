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
                    ARViewService.shared.captureScreen()
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
            
            HStack(alignment: .center) {
                
                Button {
                    Task {
                        await ARViewService.shared.showAnchorIndicator()
                    }
                } label: {
                    Image(systemName: "signpost.right.fill")
                        .foregroundColor(.primary)
                }
                
                Button {
                    Task {
                        await ARViewService.shared.createFrame()
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing], 30)
                }
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            .frame(height: 100)
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding(.bottom, (UIDevice.current.userInterfaceIdiom == .pad) ? 25 : 0)
            .padding(.leading, (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 0)
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
