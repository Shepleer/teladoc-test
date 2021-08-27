//
//  NCRequestExecutor.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 18/08/2021.
//

import Foundation

protocol RequestExecutor {
    func perform(dataRequest request: URLRequest) -> RequestTask
}

class NCRequestExecutor: NSObject, RequestExecutor {
    private var session: URLSession
    
    init(with session: URLSession) {
        self.session = session
        super.init()
    }
    
    func perform(dataRequest request: URLRequest) -> RequestTask {
        let task = session.dataTask(with: request)
        let requestTask = NCRequestTask(with: task)
        return requestTask
    }
    
    deinit {
        session.invalidateAndCancel()
    }
}
