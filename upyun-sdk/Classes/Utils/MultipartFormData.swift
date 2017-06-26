//
//  MultipartFormData.swift
//  Pods
//
//  Created by Maple Yin on 2017/6/26.
//
//

import Foundation


class MultipartFormData {
    struct EncodingCharacters {
        static let crlf = "\r\n"
    }
    
    struct BoundaryGenerator {
        enum BoundaryType {
            case initial, encapsulated, final
        }
        
        static func randomBoundary() -> String {
            return String(format: "upyunsdk.boundary.%08x%08x", arc4random(), arc4random())
        }
        
        static func boundaryData(forBoundaryType boundaryType: BoundaryType, boundary: String) -> Data {
            let boundaryText: String
            
            switch boundaryType {
            case .initial:
                boundaryText = "--\(boundary)\(EncodingCharacters.crlf)"
            case .encapsulated:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)\(EncodingCharacters.crlf)"
            case .final:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)--\(EncodingCharacters.crlf)"
            }
            
            return boundaryText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        }
    }
    
    class BodyPart {
        let headers: HTTPHeaders
        let bodyStream: InputStream
        let bodyContentLength: UInt64
        var hasInitialBoundary = false
        var hasFinalBoundary = false
        
        init(headers: HTTPHeaders, bodyStream: InputStream, bodyContentLength: UInt64) {
            self.headers = headers
            self.bodyStream = bodyStream
            self.bodyContentLength = bodyContentLength
        }
    }
    
    var contentType: String { return "multipart/form-data; boundary=\(boundary)" }
    var contentLength: UInt64 { return bodyParts.reduce(0) { $0 + $1.bodyContentLength } }
    let boundary: String
    private let streamBufferSize: Int
    private var bodyParts: [BodyPart]
    
    
    init() {
        self.boundary = BoundaryGenerator.randomBoundary()
        self.bodyParts = []

        self.streamBufferSize = 1024
    }
    
    func append(_ params:UpLoadParams) {
        for (key,value) in params.pramasDic {
            append(value.data(using: .utf8)!, withName: key)
        }
    }
    
    func append(_ data: Data, withName name: String) {
        let headers = contentHeaders(withName: name)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        
        append(stream, withLength: length, headers: headers)
    }
    
    public func append(_ data: Data, withName name: String, fileName: String) {
        let headers = contentHeaders(withName: name, fileName: fileName)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        
        append(stream, withLength: length, headers: headers)
    }
    
    func append(_ stream: InputStream, withLength length: UInt64, headers: HTTPHeaders) {
        let bodyPart = BodyPart(headers: headers, bodyStream: stream, bodyContentLength: length)
        bodyParts.append(bodyPart)
    }
    
    
    func encode() throws -> Data {
        
        var encoded = Data()
        
        bodyParts.first?.hasInitialBoundary = true
        bodyParts.last?.hasFinalBoundary = true
        
        for bodyPart in bodyParts {
            let encodedData = try encode(bodyPart)
            encoded.append(encodedData)
        }
        
        return encoded
    }
    
    // MARK: - Private - Body Part Encoding
    
    private func encode(_ bodyPart: BodyPart) throws -> Data {
        var encoded = Data()
        
        let initialData = bodyPart.hasInitialBoundary ? initialBoundaryData() : encapsulatedBoundaryData()
        encoded.append(initialData)
        
        let headerData = encodeHeaders(for: bodyPart)
        encoded.append(headerData)
        
        let bodyStreamData = try encodeBodyStream(for: bodyPart)
        encoded.append(bodyStreamData)
        
        if bodyPart.hasFinalBoundary {
            encoded.append(finalBoundaryData())
        }
        
        return encoded
    }
    
    private func encodeHeaders(for bodyPart: BodyPart) -> Data {
        var headerText = ""
        
        for (key, value) in bodyPart.headers {
            headerText += "\(key): \(value)\(EncodingCharacters.crlf)"
        }
        headerText += EncodingCharacters.crlf
        
        return headerText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    private func encodeBodyStream(for bodyPart: BodyPart) throws -> Data {
        let inputStream = bodyPart.bodyStream
        inputStream.open()
        defer { inputStream.close() }
        
        var encoded = Data()
        
        while inputStream.hasBytesAvailable {
            var buffer = [UInt8](repeating: 0, count: streamBufferSize)
            let bytesRead = inputStream.read(&buffer, maxLength: streamBufferSize)
            
            if bytesRead > 0 {
                encoded.append(buffer, count: bytesRead)
            } else {
                break
            }
        }
        
        return encoded
    }
    
    
    // MARK: - Private - Content Headers
    
    private func contentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> [String: String] {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName { disposition += "; filename=\"\(fileName)\"" }
        
        var headers = ["Content-Disposition": disposition]
        if let mimeType = mimeType { headers["Content-Type"] = mimeType }
        
        return headers
    }
    
    // MARK: - Private - Boundary Encoding
    
    private func initialBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .initial, boundary: boundary)
    }
    
    private func encapsulatedBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .encapsulated, boundary: boundary)
    }
    
    private func finalBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .final, boundary: boundary)
    }
}
