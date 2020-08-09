// Copyright (c) 2020 Benjamin Robinson

import Foundation
import MultipeerConnectivity

public protocol MPCManagerDelegate {
    
    func foundPeer(id: MCPeerID, discoveryInfo: [String : String]?)
    func lostPeer(id: MCPeerID)
    
    func connectedToPeer(id: MCPeerID)
    func disconnectedFromPeer(id: MCPeerID)
    
    func receivedInvite(from peerID: MCPeerID, context: Data?, response: @escaping (Bool) -> Void)
    
    func didReceive(data: Data, fromPeer id: MCPeerID)
    func didReceive(stream: InputStream, withName name: String, fromPeer id: MCPeerID)
    func didStartReceivingResource(withName resourceName: String, fromPeer id: MCPeerID, progress: Progress)
    func didFinishReceivingResource(withName resourceName: String, fromPeer id: MCPeerID, at localURL: URL?, withError error: Error?)
    
    func encounteredError(error: Error)
    
}

extension MPCManagerDelegate {
    
    func didReceive(data: Date, fromPeer id: MCPeerID) {
        print("didReceiveData - not implemented")
    }
    
    func didReceive(stream: InputStream, withName name: String, fromPeer id: MCPeerID) {
        print("didReceiveStream - not implemented")
    }
    
    func didStartReceivingResource(withName resourceName: String, fromPeer id: MCPeerID, progress: Progress) {
        print("didStartReceivingResource - not implemented")
    }
    
    func didFinishReceivingResource(withName resourceName: String, fromPeer id: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResource - not implemented")
    }
    
}
