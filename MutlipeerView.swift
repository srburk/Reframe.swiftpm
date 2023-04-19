//
//  MutlipeerView.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/19/23.
//

import SwiftUI

struct MutlipeerView: View {
    
    @ObservedObject var multipeerService = MultipeerService.shared
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            HStack(alignment: .center) {
                                
                Text("\((multipeerService.multipeerState == .browsing) ? "Hosting" : "Searching")")
                    .font(.system(size: 20, weight: .bold))
                
                Menu {
                    
                    if (multipeerService.multipeerState == .browsing) {
                        Button {
                            multipeerService.multipeerState = .advertising
                        } label: {
                            Text("Stop hosting")
                        }
                    } else {
                        Button {
                            multipeerService.multipeerState = .browsing
                        } label: {
                            Text("Start hosting")
                        }
                    }
                } label: {
                    Image(systemName: "chevron.down.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.gray)
                            .font(.title2)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                    VirtualGallery.shared.bottomSheetState = .normal
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                        .font(.title)
                }
            }
            
            if (multipeerService.multipeerState == .browsing) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Local Peers")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    ForEach(multipeerService.foundAdvertisers, id: \.self) { advertiserID in
                        Divider()

                        HStack {
                            Text(advertiserID.displayName)
                                .font(.subheadline)
                            Spacer()
                            
                            Button {
                                multipeerService.sendRequest(to: advertiserID)
                            } label: {
                                Text("Invite")
                                    .padding([.trailing, .leading], 15)
                                    .padding([.bottom, .top], 5)
                                    .background(Color.buttonGray, in: RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                                        
                    HStack {
                        Spacer()
                    }
                }
            }
            
            if (multipeerService.multipeerState == .advertising) {
                VStack(alignment: .leading) {
                    Text("Connected: \(multipeerService.session.connectedPeers.count)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray)
                                        
                    HStack {
                        Spacer()
                    }
                }
            }
            
            Spacer()

        }
        .padding([.leading, .trailing, .bottom])
        .onAppear {
            multipeerService.multipeerState = .browsing
        }
    }
}

struct MutlipeerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Spacer()
            
            VStack {
                MutlipeerView()
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
