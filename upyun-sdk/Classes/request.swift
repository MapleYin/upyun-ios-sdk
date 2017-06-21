//
//  request.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation

/// <#Description#>
///
/// - Meta: 获取图片信息
/// - ThemeColor: 获取图片主题色
enum GmkerlType : String {
    case Meta = "get_meta"
    case ThemeColor = "get_theme_color"
}

struct SizeRange<T> {
    var min:T
    var max:T
}


struct UpLoadParams {
    var bucket : String  // 文件上传到的服务
    var saveKey : String  // 文件保存路径
    var expiration : TimeInterval // 请求的过期时间
    var date : Date? // 请求日期时间
    var contentMD5 : String? // 上传文件的 MD5 值
    var returnUrl : String? // 同步通知 URL
    var notifyUrl : String? // 异步通知 URL
    var contentSecret : String? // 文件密钥，用于保护文件，防止文件被直接访问
    var contentType : String? // 文件类型，默认使用文件扩展名作为文件类型
    var allowFileType : String? // 允许上传的文件扩展名，以 , 分隔。如 jpg,jpeg,png
    var contentLengthRange : SizeRange<Double>? // 文件大小限制
    var imageWidthRange : SizeRange<Int>? // 图片宽度限制
    var imageHeightRange : SizeRange<Int>? // 图片高度限制
    var xGmkerlThumb : String? // 图片预处理
    var xGmkerlType : GmkerlType?
    var apps : String? // 异步预处理
    var b64encoded:Bool = false // 对通过 Base64 编码上传的文件进行 Base64 解码
    var extParam : String? // 额外参数
}



class Request {
    init() {
        
    }
}
