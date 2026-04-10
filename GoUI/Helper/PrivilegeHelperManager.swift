//
//  PrivilegeHelperManager.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import Foundation

final class PrivilegedHelperManager {
    static let shared = PrivilegedHelperManager()

    private let machServiceName = "com.aditya.zabbix.helper"

    private func connection() -> NSXPCConnection {
        let connection = NSXPCConnection(machServiceName: machServiceName, options: .privileged)
        connection.remoteObjectInterface = NSXPCInterface(with: GoUIHelperProtocol.self)
        connection.resume()
        return connection
    }

    func setFanMinSpeed(_ rpm: Int, completion: @escaping (Bool, String) -> Void) {
        let conn = connection()

        guard let proxy = conn.remoteObjectProxyWithErrorHandler({ error in
            completion(false, error.localizedDescription)
        }) as? GoUIHelperProtocol else {
            completion(false, "Failed to connect to helper")
            return
        }

        proxy.setFanMinSpeed(NSNumber(value: rpm)) { ok, message in
            completion(ok.boolValue, message as String)
            conn.invalidate()
        }
    }

    func resetFanAuto(completion: @escaping (Bool, String) -> Void) {
        let conn = connection()

        guard let proxy = conn.remoteObjectProxyWithErrorHandler({ error in
            completion(false, error.localizedDescription)
        }) as? GoUIHelperProtocol else {
            completion(false, "Failed to connect to helper")
            return
        }

        proxy.resetFanAuto { ok, message in
            completion(ok.boolValue, message as String)
            conn.invalidate()
        }
    }
}
