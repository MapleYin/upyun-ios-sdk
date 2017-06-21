//
//  encode.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation
import CryptoSwift

extension String {
    func base64Encode() -> String? {
        let stringData = self.data(using: .utf8)
        let base64String = stringData?.base64EncodedString()
        return base64String
    }
    
    func base64Decode() -> String? {
        if let stringData = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: UInt(0))) {
            let string = String(data: stringData, encoding: .utf8)
            return string;
        } else {
            return nil
        }
    }
}
