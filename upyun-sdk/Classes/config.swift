//
//  config.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation

public enum Schema {
    case HTTPS,HTTP
}

public enum Host:String {
    case AUTO = "v0.api.upyun.com"   // auto choose
    case CT = "v1.api.upyun.com"     // China Telecom
    case CU = "v2.api.upyun.com"     // China Unicom
    case CM = "v3.api.upyun.com"     // China Mobile
}

public enum Method:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case head = "HEAD"
}
