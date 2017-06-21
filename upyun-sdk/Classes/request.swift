//
//  request.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation

struct UpLoadParams {
    var bucket : String  // 文件上传到的服务
    var saveKey : String  // 文件保存路径
    var expiration : TimeInterval //
    var date : Date?
    var contentMD5 : String?
    var returnUrl : String?
    var notifyUrl : String?
    var contentSecret : String?
    var contentType : String?
    var allowFileType : String?
    var contentLengthRange : String?
    var imageWidthRange : String?
    var imageHeightRange : String?
    var xGmkerlThumb : String?
    var xGmkerlType : String?
    var apps : String?
    var b64encoded:String?
    var extParam : String?
}

class Request {
    init() {
        
    }
}
