//
//  HelperProtocol.swift
//  GoUI
//
//  Created by ADITYA PRASETYO on 10/04/26.
//

import Foundation

@objc protocol GoUIHelperProtocol {
    func setFanMinSpeed(_ rpm: NSNumber, withReply reply: @escaping (NSNumber, NSString) -> Void)
    func resetFanAuto(_ reply: @escaping (NSNumber, NSString) -> Void)
}
