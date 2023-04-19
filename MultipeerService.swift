//
//  MultipeerService.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/19/23.
//

import Foundation
import MultipeerConnectivity

final class MultipeerService: NSObject, ObservableObject {
    
    static let shared = MultipeerService()
        
    @Published var multipeerState = MultipeerState.none {
        didSet {
            switch (multipeerState) {
                case .none:
                    nearbyServiceAdvertiser.stopAdvertisingPeer()
                    nearbyServiceBrowser.stopBrowsingForPeers()
                case .advertising:
                    self.foundAdvertisers = []
                    nearbyServiceBrowser.stopBrowsingForPeers()
                    nearbyServiceAdvertiser.startAdvertisingPeer()
                    print("Started advertising service")
                case .browsing:
                    nearbyServiceBrowser.startBrowsingForPeers()
                    nearbyServiceAdvertiser.stopAdvertisingPeer()
                    print("Started browsing services")
            }
        }
    }
    
    @Published var foundAdvertisers: [MCPeerID] = []
    
    public let session: MCSession
    
    private let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    private let nearbyServiceBrowser: MCNearbyServiceBrowser
    
    private let peerID = UIDevice.modelName
    
    override init() {
        session = MCSession(peer: MCPeerID(displayName: peerID), securityIdentity: nil, encryptionPreference: .required)
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: MCPeerID(displayName: peerID), discoveryInfo: nil, serviceType: "reframe-collab")
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: MCPeerID(displayName: peerID), serviceType: "reframe-collab")
        
        super.init()

        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }
}

extension MultipeerService {
    static var preview: MultipeerService {
        let service = MultipeerService()
        
        service.foundAdvertisers = [
            .init(displayName: "iPad Pro"),
            .init(displayName: "Sam's iPhone 14 Pro")
        ]
        
        return service
    }
}

extension MultipeerService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundAdvertisers.append(peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to start looking for peers: \(error.localizedDescription)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }
    
    func sendRequest(to peerID: MCPeerID) {
        self.nearbyServiceBrowser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
}

extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Failed to start advertising service: \(error.localizedDescription)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
}
