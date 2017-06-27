
//  authorization.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation
import CryptoSwift


struct Authorization {
    var `operator`:String
    var method : HTTPMethod
    var uri : String
    var date : Date
    var contentMd5 : String?
    var password : String

    init(_ `operator`:String = Config.global.username,
         password:String = Config.global.password,
         method:HTTPMethod,
         uri:String,
         date:Date = Date(),
         contentMd5:String?
         ) {
        self.`operator` = `operator`
        self.password = password
        self.method = method
        self.uri = uri
        self.date = date
        self.contentMd5 = contentMd5
    }
    
    
}

extension Authorization {
    
    /// 生成签名
    var signature:String {
        let mirror = Mirror(reflecting: self)
        var params = [String]()
        for (labelMaybe, valueMaybe) in mirror.children {
            guard let label = labelMaybe,let validValue = unwrap(valueMaybe),label != "password" else {
                continue
            }

            switch validValue {
            case let date as Date:
                params.append(date.standFormat())
            case let method as HTTPMethod:
                params.append(method.rawValue)
            case let stringValue as String:
                params.append(stringValue)
            default:
                continue
            }
        }
        let signatureOrigin = params.joined(separator: "&")
        let signature = try! HMAC(key: password.md5(), variant: .sha1).authenticate(signatureOrigin.utf8.lazy.map({ $0 as UInt8 })).toBase64()!
        return "UPYUN \(`operator`):\(signature)"
    }
}
