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
                Spacer()
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
            }
            .padding(.top, 50)
            .padding(.trailing, 10)
            
            Spacer()
            
            HStack(alignment: .center) {
                
                Button {
                    Task {
                        await ARViewService.shared.newFrame()
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
            .frame(height: 200)
            
            .frame(maxWidth: (UIDevice.current.userInterfaceIdiom == .pad) ? 350 : .infinity)
            
            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20))
            
            .padding(.bottom, (UIDevice.current.userInterfaceIdiom == .pad) ? 28 : 0)
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
