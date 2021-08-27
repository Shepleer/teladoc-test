//
//  NCSessionDelegate.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 19/08/2021.
//

import Foundation

protocol SessionDelegate: AnyObject {
    func session(dataTask: URLSessionDataTask, didReceive data: Data)
    func session(didCompleteTask task: URLSessionTask, withError: Error?)
}

// url session have a strong reference to delegate, so we need that provider to avoid reference cycles whitout manual session invalidation
class NCSessionDelegate: NSObject {
    // weak var state: State?
    weak var delegate: SessionDelegate?
}

extension NCSessionDelegate: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        delegate?.session(dataTask: dataTask, didReceive: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        delegate?.session(didCompleteTask: task, withError: error)
    }
}
