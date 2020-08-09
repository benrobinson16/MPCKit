# MPCKit

A simple wrapper for the MultipeerConnectivity framework provided by Apple.

## Set up:

1. Add `NSLocalNetworkUsageDescription` key to your `Info.plist` file (required on iOS 14+)
2. Add `NSBonjourServices` key to your `Info.plist` file. Add two items to the array: `_your-service._tcp` and `_your-service._udp`
3. Create a delegate conforming to `MPCManagerDelegate` protocol in order to receive updates from the `MPCManager`.
4. Create an instance of class `MPCManager` in your app. Only one instance should be made.

```swift
import MPCKit

// Create the manager
let myManager = MPCManager()
myManager.delegate = self

// To start and stop advertising...
myManager.start(.advertising)
myManager.stop(.advertising)

// To start and stop browsing...
myManager.start(.browsing)
myManager.stop(.browsing)

// To start and stop new connections...
myManager.start(.newConnections)
myManager.stop(.newConnections)

// To start and stop all connections (including existing)...
myManager.start(.allConnections)
myManager.stop(.allConnections)
```
## The delegate:

All changes that occur in the MPCManager class are reported via the delegate. 

### There are six required methods:

```swift
func foundPeer(id: MCPeerID, discoveryInfo: [String : String]?)
```
Notifies the delegate that a peer has been found. If you wish to invite the peer, call `func invite(peer: MCPeerID)` on the manager object.<br><br>

```swift
func lostPeer(id: MCPeerID)
```
Notifies the delegate that a peer is no longer available for connection.<br><br>

```swift
func connectedToPeer(id: MCPeerID)
```
Notifies the delegate that a peer has been successfully connected to.<br><br>

```swift
func disconnectedFromPeer(id: MCPeerID)
```
Notifies the delegate that a peer has disconnected from the session.<br><br>

```swift
func receivedInvite(from peerID: MCPeerID, context: Data?, response: @escaping (Bool) -> Void)
```
Notifies the delegate that an invite has been received. Call `response(true)` to accept or `response(false)` to decline.<br><br>

```swift
func encounteredError(error: Error)
```
Notifies the delegate that an error has been encountered, providing an opportunity to present an error message to the user.<br><br>

### There are four optional methods:

The following methods are optional because although every use case will require at least one of these, most only require one.<br><br>

```swift
func didReceive(data: Data, fromPeer id: MCPeerID)
```
Notifies the delegate that data has been received.<br><br>

```swift
func didReceive(stream: InputStream, withName name: String, fromPeer id: MCPeerID)
```
Notifies the delegate that a stream has been received.<br><br>

```swift
func didStartReceivingResource(withName resourceName: String, fromPeer id: MCPeerID, progress: Progress)
```
Notifies the delegate that resources are starting to be received.<br><br>

```swift
func didFinishReceivingResource(withName resourceName: String, fromPeer id: MCPeerID, at localURL: URL?, withError error: Error?)
```
Notifies the delegate that resources have been delivered to the specified local URL.<br><br>

## License

Copyright (c) 2020 Benjamin Robinson.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
