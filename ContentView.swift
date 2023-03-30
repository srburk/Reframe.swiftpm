import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        ZStack {
            ARViewContainer()
            ARViewOverlay()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
