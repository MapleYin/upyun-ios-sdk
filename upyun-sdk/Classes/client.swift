//
//  client.swift
//  Pods
//
//  Created by Mapleiny on 2017/6/20.
//
//

import Foundation

public typealias ResponseHandleBlock = (_ recivedData:Data?,_ error:Error?) -> Void
public typealias ProgressHandleBlock = (Progress) -> Void

public class Client : NSObject {
    
    var task : URLSessionTask?
    var responseHandle:ResponseHandleBlock?
    var progressHandle:ProgressHandleBlock?
    let progress = Progress()
    
    public override init() {
        super.init()
        progress.cancellationHandler = {
            [unowned self] in
            self.task?.cancel()
        }
    }
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
    
    @discardableResult
    public func progress(progressHandle:@escaping ProgressHandleBlock) -> Client {
        self.progressHandle = progressHandle
        return self
    }
    
    @discardableResult
    public func response(responseHandle:@escaping ResponseHandleBlock) -> Client {
        self.responseHandle = responseHandle
        return self
    }
    
    public func resume() {
        task?.resume()
    }
    
    public func cancel() {
        task?.cancel()
    }
}

// MARK: - URLSessionDataDelegate

extension Client : URLSessionDataDelegate {
    
    // MARK: - Send Progress
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        progress.completedUnitCount = totalBytesSent
        progress.totalUnitCount = totalBytesExpectedToSend
        progressHandle?(progress)
    }
    
    // MARK: -
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("urlSession:dataTask:didReceive:\(data)")
    }
    
    // MARK: - Response
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("urlSession:dataTask:didReceive:completionHandler:\(response)")
    }
    
    // MARK: - Request Complete
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("urlSession:task:didCompleteWithError:error:\(task)")
    }
}


// MARK: - URLSessionDownloadDelegate

extension Client : URLSessionDownloadDelegate {
    
    // MARK: - Download Finish
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    // MARK: - Download progress
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress.completedUnitCount = totalBytesWritten
        progress.totalUnitCount = totalBytesExpectedToWrite
        progressHandle?(progress)
    }
    
    // MARK: - Download resumed
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
}


