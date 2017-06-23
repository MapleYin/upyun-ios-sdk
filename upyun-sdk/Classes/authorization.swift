//
//  authorization.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation

func CreateAuthorisedString(
    operatorString:String,
    password:String,
    uri:String,
    method:Method = .get,
    policy
    date:Date = Date(),
    ContentMD5:String? = nil) -> String {
    
    // password
    let passwordEncode = password.md5()
    
    // date
    let formatedString = date.standFormat()
    
    let signatureOrigin = "\(passwordEncode),\(method.rawValue)&\(uri)&\(formatedString)"
    let signature = signatureOrigin.utf8.lazy.map({ $0 as UInt8 }).sha1().toBase64()
    return "UPYUN \(operatorString):\(signature!)"
}
