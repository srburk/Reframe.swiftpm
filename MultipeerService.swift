//
//  MultipeerService.swift
//  Reframe
//
//  Created by Sam Burkhard on 4/19/23.
//

import Foundation
import MultipeerConnectivity
import RealityKit

final class MultipeerService: NSObject, ObservableObject {
    
    static let shared = MultipeerService()
        
    public let session: MCSession
    
    private let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    private let nearbyServiceBrowser: MCNearbyServiceBrowser
    
    private let localPeer = MCPeerID(displayName: UIDevice.current.name)

    override init() {
        
        session = MCSession(peer: localPeer, securityIdentity: nil, encryptionPreference: .required)
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: localPeer, discoveryInfo: nil, serviceType: "reframe-collab")
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: localPeer, serviceType: "reframe-collab")
        
        super.init()

        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
        
        nearbyServiceBrowser.startBrowsingForPeers()
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    func sendToPeers(_ data: Data, reliably: Bool, peers: [MCPeerID]) {
        guard !peers.isEmpty else { return }
        do {
            try session.send(data, toPeers: peers, with: reliably ? .reliable : .unreliable)
//            print("Sent data to peers")
        } catch {
            print("error sending data to peers \(peers): \(error.localizedDescription)")
        }
    }
}

extension MultipeerService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found peer – \(peerID.displayName)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to start looking for peers: \(error.localizedDescription)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }
}

extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Received invitation from peer – \(peerID.displayName)")
        invitationHandler(true, self.session)
    }
}

extension MultipeerService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            print("Peer joined")
            
        } else if state == .notConnected {
            print("Peer left")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Receiving recourse: \(resourceName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
