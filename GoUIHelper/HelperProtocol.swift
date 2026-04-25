//
//  HelperProtocol.swift
//  GoUIHelper
//
//  Created by ADITYA PRASETYO on 12/04/26.
//

import Foundation

@objc protocol HelperProtocol {
    func getVersion(reply: @escaping (String) -> Void)
    func getFanInfo(reply: @escaping ([[String: Any]]) -> Void)
    func setFanMinSpeed(_ rpm: Int, reply: @escaping (Bool, String) -> Void)
    func resetFanAuto(reply: @escaping (Bool, String) -> Void)
}
