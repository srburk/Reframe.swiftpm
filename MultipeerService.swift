//
//  MultipeerService.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/19/23.
//

import Foundation
import MultipeerConnectivity

final class MultipeerService: NSObject {
    
    static let shared = MultipeerService()
    
    public let session: MCSession
    
    public let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    public let nearbyServiceBrowser: MCNearbyServiceBrowser
    
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

extension MultipeerService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("FOUND PEER FOR SERVICE: \(peerID.displayName)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to start looking for peers: \(error.localizedDescription)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }
}

extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Failed to start advertising service: \(error.localizedDescription)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Received invitation from peer: \(peerID.displayName)")
    }
}
