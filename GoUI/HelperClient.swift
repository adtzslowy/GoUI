import Foundation

final class HelperClient {
    private var connection: NSXPCConnection?
    
    func connect() {
        connection = NSXPCConnection(
            machServiceName: "adtzslowy.xyz.GoUIHelper",
            options: .privileged
        )
        
        connection?.remoteObjectInterface = NSXPCInterface(with: HelperProtocol.self)
        connection?.resume()
    }
    
    func proxy() -> HelperProtocol? {
        connection?.remoteObjectProxyWithErrorHandler {error in
            print("XPC error: ", error)
        } as? HelperProtocol
    }
 }
