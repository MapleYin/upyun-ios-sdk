//
//  client.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation

public class Client : NSObject {
    
    fileprivate var task : URLSessionTask?
    
    
}

// MARK: - Init

extension Client {
    static func upload(_ urlRequest:URLRequest, fileData:Data) -> Client {
        
        let client = Client()
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpCookieStorage = HTTPCookieStorage.shared
        sessionConfiguration.httpCookieAcceptPolicy = .always
        sessionConfiguration.httpShouldSetCookies = true
        
        let session = URLSession(configuration: sessionConfiguration, delegate: client, delegateQueue: nil)
        
        let task = session.uploadTask(with: urlRequest, from: fileData)
        
        client.task = task
        
        return client
    }
    
    static func download(_ urlRequest:URLRequest) -> Client {
        let client = Client()
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpCookieStorage = HTTPCookieStorage.shared
        sessionConfiguration.httpCookieAcceptPolicy = .always
        sessionConfiguration.httpShouldSetCookies = true
        
        let session = URLSession(configuration: sessionConfiguration, delegate: client, delegateQueue: nil)
        
        let task = session.downloadTask(with: urlRequest)
        
        client.task = task
        
        return client
    }
}

// MARK: - Operation

extension Client {
    public func cancel() {
        task?.cancel()
    }
}

// MARK: - URLSessionDataDelegate

extension Client : URLSessionDataDelegate {
    
    // MARK: - Send Progress
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    // MARK: - Download
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
    
    // MARK: - Response
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
    }
    
    // MARK: - Request Complete
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
}


