//
//  client.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation


class Client {
    static let shared = Client()
    
    
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpCookieStorage = HTTPCookieStorage.shared
        sessionConfiguration.httpCookieAcceptPolicy = .always
        sessionConfiguration.httpShouldSetCookies = true
        
        

    }
}
