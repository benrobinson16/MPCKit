// Copyright (c) 2020 Benjamin Robinson

import Foundation
import MultipeerConnectivity

// MARK: - MPCManager

public class MPCManager: NSObject {
    
    // MARK: Properties
    
    public var delegate: MPCManagerDelegate?
    
    public var peer: MCPeerID!
    
    private var session: MCSession!
    private var browser: MCNearbyServiceBrowser!
    private var advertiser: MCNearbyServiceAdvertiser!
    
    private var serviceType: String!
    
    private var sendDataMode: MCSessionSendDataMode = .reliable
    
    // MARK: Computed Properties
    
    public var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
    
    public var numConnected: Int {
        return connectedPeers.count
    }
    
    // MARK: Init
    
    public init(serviceType: String, myDisplayName: String = UIDevice.current.name) {
        
        super.init()
        
        self.serviceType = serviceType
        
        peer = MCPeerID(displayName: UIDevice.current.name)
        
        session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        
    }
    
    public override init() {
        
        fatalError("Not implemented. Please use init(serviceType:, myDisplayName:).")
        
    }
    
    // MARK: Starting and stopping
    
    public func start(_ option: MPCKitObject) {
        switch option {
        case .advertising:
            advertiser.startAdvertisingPeer()
        case .browsing:
            browser.startBrowsingForPeers()
        case .newConnections, .allConnections:
            advertiser.startAdvertisingPeer()
            browser.startBrowsingForPeers()
        }
    }
    
    public func stop(_ option: MPCKitObject) {
        switch option {
        case .advertising:
            advertiser.stopAdvertisingPeer()
        case .browsing:
            browser.stopBrowsingForPeers()
        case .newConnections:
            advertiser.stopAdvertisingPeer()
            browser.stopBrowsingForPeers()
        case .allConnections:
            advertiser.stopAdvertisingPeer()
            browser.stopBrowsingForPeers()
            session.disconnect()
        }
    }
    
    // MARK: Sending Data
    
    public func sendDataToAll(_ dataToSend: Data) throws {
        
        try sendData(dataToSend, toPeers: connectedPeers)
        
    }
    
    public func sendData(_ dataToSend: Data, toPeers peers: [MCPeerID]) throws {
        
        try session.send(dataToSend, toPeers: peers, with: sendDataMode)
        
    }
    
    // MARK: Inviting
    
    public func invite(peer: MCPeerID) {
        
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 30)
        
    }
    
}

// MARK: - Session Delegate

extension MPCManager: MCSessionDelegate {
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            delegate?.connectedToPeer(id: peerID)
        } else if state == .notConnected {
            delegate?.disconnectedFromPeer(id: peerID)
        }
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate?.didReceive(data: data, fromPeer: peerID)
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        delegate?.didReceive(stream: stream, withName: streamName, fromPeer: peerID)
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        delegate?.didStartReceivingResource(withName: resourceName, fromPeer: peerID, progress: progress)
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        delegate?.didFinishReceivingResource(withName: resourceName, fromPeer: peerID, at: localURL, withError: error)
    }
    
}

// MARK: - Browser Delegate

extension MPCManager: MCNearbyServiceBrowserDelegate {
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        delegate?.foundPeer(id: peerID, discoveryInfo: info)
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.lostPeer(id: peerID)
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("error starting browsing")
        print(error.localizedDescription)
        delegate?.encounteredError(error: error)
    }
    
}

// MARK: - Advertiser Delegate

extension MPCManager: MCNearbyServiceAdvertiserDelegate {
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let handler: (Bool) -> Void = { accepted in
            invitationHandler(accepted, self.session)
        }
        delegate?.receivedInvite(from: peerID, context: context, response: handler)
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("error starting browsing")
        print(error.localizedDescription)
        delegate?.encounteredError(error: error)
    }
    
}
