//
//  ContentView.swift
//  Reframe
//
//  Created by Sam Burkhard on 3/29/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var arVM = ARViewModel()
    
    var body: some View {
        
//        PictureSelectionView()
        
        ZStack {
            ARViewContainer()
            ARViewOverlay()
        }
        .edgesIgnoringSafeArea(.all)
        .environmentObject(arVM)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
