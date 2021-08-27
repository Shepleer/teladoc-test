//
//  NetworkClient.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 16/08/2021.
//

import Foundation

typealias NCTaskCompletion = (_ data: Data?, _ error: NCError?) -> Void

protocol INetworkClient {
    
}

class NetworkClient {
    typealias RequestId = Int
    
    private var requestBuilder: RequestBuilder
    private var requestExecutor: RequestExecutor
    private var responseParser: ResponseHandler
    private var retrier: Retrier
    private var state: NCState
    
    let processQueue = DispatchQueue(label: "processQueue", qos: .userInitiated, attributes: .concurrent)
    
    init(
        builder: RequestBuilder,
        executor: RequestExecutor,
        parcer: ResponseHandler,
        retrier: Retrier
    ) {
        self.requestBuilder = builder
        self.requestExecutor = executor
        self.responseParser = parcer
        self.retrier = retrier
        self.state = NCState(state: [:])
    }
    
    @discardableResult
    func run<R: RequestModel>(model: R, completion: @escaping NCTaskCompletion) throws -> RequestTask {
        let request = try requestBuilder.makeRequest(from: model)
        var task = requestExecutor.perform(dataRequest: request)
        task.completion = completion
        state.updateTask(task, for: task.taskId)
        task.run()
        
        return task
    }
    
    private func handleError() {
        
    }
}

extension NetworkClient: SessionDelegate {
    func session(didCompleteTask task: URLSessionTask, withError error: Error?) {
        guard let completedTask = state.getTask(with: task.taskIdentifier) else {
            return
        }
        if let error = error {
            //todo: apply retrier here
            DispatchQueue.main.async {
                completedTask.completion?(nil, .networkError(.urlSessionError(error)))
            }
            return
        }
        if let response = completedTask.response as? HTTPURLResponse {
            let ncResponse = NCResponse(
                taskId: completedTask.taskId,
                statusCode: response.statusCode,
                data: completedTask.data,
                error: error
            )
            guard let data = try? responseParser.parce(response: ncResponse) else {
                return
            }
            completedTask.completion?(data, nil)
            state.deleteTask(with: task.taskIdentifier)
        }
    }
    
    func session(dataTask: URLSessionDataTask, didReceive data: Data) {
        state.appendData(for: dataTask.taskIdentifier, data: data)
    }
}
