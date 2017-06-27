//
//  upload.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation

public struct UpLoadParams {
    var bucket : String
    var path : String
    var date : Date
    var contentMd5 : String?
    var contentType : String?
    var contentSecret : String?
    var xUpyunMeta : String?
    var xGmkerlThumb : String?
    
    public init(_ bucket:String = Config.global.bucket,
         path:String,
         date:Date = Date(),
         contentMd5:String? = nil,
         contentType:String? = nil,
         contentSecret:String? = nil,
         xUpyunMeta:String? = nil,
         xGmkerlThumb:String? = nil
         ) {
        self.bucket = bucket
        self.path = path
        self.date = date
        self.contentMd5 = contentMd5
        self.contentType = contentType
        self.contentSecret = contentSecret
        self.xUpyunMeta = xUpyunMeta
        self.xGmkerlThumb = xGmkerlThumb
    }
    
    var requireUrl:URL {
        guard let url = URL(string: "\(Config.global.schema)://\(Config.global.host.rawValue)/\(bucket)/\(path)") else {
            assert(true, "Error `bucket`:\(bucket) Or `path`:\(path)")
            return URL(string: "\(Config.global.schema)://\(Config.global.host.rawValue)")!
        }
        
        return url
    }
    
    var uri : String {
        return "/\(bucket)/\(path)"
    }
}

public func Upload(_ file:Data, params:UpLoadParams) throws -> Client {
    
    var request = URLRequest(url: params.requireUrl)
    request.httpMethod = HTTPMethod.put.rawValue
    
    // Authorization
    let authorization = Authorization(method: .put, uri: params.uri, date:params.date, contentMd5: params.contentMd5)
    
    // HTTP Header
    
    
    return Client.upload(request, fileData: file)
}
