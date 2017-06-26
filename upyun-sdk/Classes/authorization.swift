
//  authorization.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation
import CryptoSwift

func CreateAuthorisedString(
    `operator`:String,
    password:String,
    uri:String,
    method:Method = .get,
    policy:UpLoadParams,
    ContentMD5:String? = nil) -> String {
    
    // password
    let passwordEncode = password.md5()
    
    
    
    let signatureOrigin = "\(method.rawValue)&\(uri)&\(policy.encode!)"
    
    let signature = try! HMAC(key: passwordEncode, variant: .sha1).authenticate(signatureOrigin.utf8.lazy.map({ $0 as UInt8 })).toBase64()!
    return "UPYUN \(`operator`):\(signature)"
}
