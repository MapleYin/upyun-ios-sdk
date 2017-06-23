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

public struct Config {
    
    private static var _global:Config?
    
    static var global:Config {
        assert(_global == nil, "You Need Set Global Config Call `Config.setGlobal(username:password:)`")
        return _global!
    }
    
    static func setGlobal(username:String,password:String){
        self._global = Config(username: username,password: password)
    }
    
    init(username:String,password:String) {
        self.username = username
        self.password = password
    }
    
    var schema:Schema = .HTTPS
    var host:Host = .AUTO
    
    var username : String
    var password : String
}

