import Foundation

class HelperDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener,
                  shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let interface = NSXPCInterface(with: HelperProtocol.self)
        newConnection.exportedInterface = interface
        newConnection.exportedObject = FanHelper()
        newConnection.resume()
        return true
    }
}

let machService = "adtzslowy.xyz.GoUIHelper"
let delegate = HelperDelegate()
let listener = NSXPCListener(machServiceName: machService)
listener.delegate = delegate
listener.resume()


RunLoop.main.run()
