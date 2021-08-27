//
//  NCRequest.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 18/08/2021.
//

import Foundation

protocol RequestTask {
    var completion: NCTaskCompletion? { get set }
    var isCanceled: Bool { get }
    var data: Data { get set }
    var taskId: Int { get }
    var response: URLResponse? { get }
    func cancel()
    func run()
}

protocol RequestTaskDelegate {
    
}

class NCRequestTask: RequestTask {    
    var completion: NCTaskCompletion?
    var isCanceled = false
    var data: Data = .init()
    private let task: URLSessionTask
    
    var taskId: Int {
        task.taskIdentifier
    }
    
    var response: URLResponse? {
        task.response
    }
    
    init(with task: URLSessionTask) {
        self.task = task
    }
    
    func run() {
        task.resume()
    }
    
    func cancel() {
        isCanceled = true
        task.cancel()
    }
}
