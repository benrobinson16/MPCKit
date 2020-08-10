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
    
    public func foundPeer(id: MCPeerID, discoveryInfo: [String : String]?) {
        print("foundPeer - not implemented")
    }
    
    public func lostPeer(id: MCPeerID) {
        print("lostPeer - not implemented")
    }
    
    func receivedInvite(from peerID: MCPeerID, context: Data?, response: @escaping (Bool) -> Void) {
        print("receivedInvite - not implemented")
    }
    
    public func didReceive(data: Date, fromPeer id: MCPeerID) {
        print("didReceiveData - not implemented")
    }
    
    public func didReceive(stream: InputStream, withName name: String, fromPeer id: MCPeerID) {
        print("didReceiveStream - not implemented")
    }
    
    public func didStartReceivingResource(withName resourceName: String, fromPeer id: MCPeerID, progress: Progress) {
        print("didStartReceivingResource - not implemented")
    }
    
    public func didFinishReceivingResource(withName resourceName: String, fromPeer id: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResource - not implemented")
    }
    
}
