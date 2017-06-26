//
//  upload.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation

/// 返回图片相关信息
///
/// - Meta: 获取图片信息
/// - ThemeColor: 获取图片主题色
public enum GmkerlType : String {
    case Meta = "get_meta"
    case ThemeColor = "get_theme_color"
}

public struct SizeRange<T>:CustomStringConvertible {
    var min:T
    var max:T
    
    public init(min:T,max:T) {
        self.min = min
        self.max = max
    }
    
    public var description: String {
        return "\(min),\(max)"
    }
}

public struct UpLoadParams {
    
    public init(bucket:String, saveKey:String) {
        self.bucket = bucket
        self.saveKey = saveKey
    }
    
    public var bucket : String  // 文件上传到的服务
    public var saveKey : String  // 文件保存路径
    public var expiration : TimeInterval = Date().timeIntervalSince1970+1800 // 请求的过期时间
    public var date : Date? // 请求日期时间
    public var contentMD5 : String? // 上传文件的 MD5 值
    public var returnUrl : String? // 同步通知 URL
    public var notifyUrl : String? // 异步通知 URL
    public var contentSecret : String? // 文件密钥，用于保护文件，防止文件被直接访问
    public var contentType : String? // 文件类型，默认使用文件扩展名作为文件类型
    public var allowFileType : String? // 允许上传的文件扩展名，以 , 分隔。如 jpg,jpeg,png
    public var contentLengthRange : SizeRange<Double>? // 文件大小限制
    public var imageWidthRange : SizeRange<Int>? // 图片宽度限制
    public var imageHeightRange : SizeRange<Int>? // 图片高度限制
    public var xGmkerlThumb : String? // 图片预处理 TODO
    public var xGmkerlType : GmkerlType? // 返回图片相关信息
    public var apps : String? // 异步预处理   TODO
    public var b64encoded:Bool? // 对通过 Base64 编码上传的文件进行 Base64 解码
    public var extParam : String? // 额外参数
    
    public var pramasDic:[String: String] {
        let mirror = Mirror(reflecting: self)
        var result: [String: String] = [:]
        for (labelMaybe, valueMaybe) in mirror.children {
            
            guard let label = labelMaybe,let validValue = unwrap(valueMaybe) else {
                continue
            }
            
            let validateLabel = keySwitch(label)
            
            var value:String;

            switch validValue {
                
            case let str as String:
                value = str
            case let date as Date:
                value = date.standFormat()
            case let gmkerlType as GmkerlType:
                value = gmkerlType.rawValue
            case let bool as Bool:  // for b64encoded
                if bool {
                    value = "on"
                } else {
                    continue
                }
            case let stringConvertible as CustomStringConvertible:
                value = stringConvertible.description
            default:
                continue
            }
            result[validateLabel] = value
        }

        return result
    }
    
    public var encode:String? {
        let jsonData = try! JSONSerialization.data(withJSONObject: self.pramasDic, options: .init(rawValue: 0))
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString?.base64Encode()
    }
    
    private func keySwitch(_ key:String) -> String {
        return key.replacingOccurrences(of: "([a-zA-Z0-9])(?=[A-Z])", with: "$1-", options: .regularExpression, range: Range(uncheckedBounds: (lower: key.startIndex, upper: key.endIndex))).lowercased()
    }
}

public func Upload(_ file:Data, params:UpLoadParams) throws -> Client {
    
    let urlString = "\(Config.global.schema)://\(Config.global.host.rawValue)/\(params.bucket)"
    
    guard let url = URL(string: urlString) else {
        assert(true, "Error `bucket` string")
        return Client()
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Authorization
    let authorisedString = CreateAuthorisedString(operator: Config.global.username,
                                                  password: Config.global.password,
                                                  uri: "/\(params.bucket)",
                                                  method: .post,
                                                  policy: params,
                                                  ContentMD5: nil)
    
    
    
    let body = MultipartFormData()
    body.append(authorisedString.data(using: .utf8)!, withName: "authorization")
    body.append((params.encode!.data(using: .utf8))!,withName:"policy")
    body.append(params)
    body.append(file, withName: "file", fileName: "test.png")
    
    request.setValue(body.contentType, forHTTPHeaderField: "Content-Type")

    let encodeData = try body.encode()
    return Client.upload(request, fileData: encodeData)
}
