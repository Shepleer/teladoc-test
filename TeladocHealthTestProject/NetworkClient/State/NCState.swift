//
//  NCState.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 20/08/2021.
//

import Foundation

// We store here active tasks with completions & data, that state also thread-safe
class NCState {
    typealias TaskId = Int
    
    private var state: [TaskId: RequestTask]
    private var stateQueue = DispatchQueue(label: "stateQueue", attributes: .concurrent)
    
    init(state: [TaskId: RequestTask]) {
        self.state = state
    }
    
    func getTask(with id: TaskId) -> RequestTask? {
        var task: RequestTask?
        stateQueue.sync {
            task = state[id]
        }
        return task
    }
    
    @discardableResult
    func deleteTask(with id: TaskId) -> RequestTask? {
        var value: RequestTask?
        self.stateQueue.async(flags: .barrier) {
            value = self.state.removeValue(forKey: id)
        }
        return value
    }
    
    @discardableResult
    func updateTask(_ task: RequestTask, for id: TaskId) -> RequestTask? {
        var value: RequestTask?
        stateQueue.async(flags: .barrier) {
            value = self.state.updateValue(task, forKey: id)
        }
        return value
    }
    
    func appendData(for taskId: TaskId, data: Data) {
        var task = state[taskId]
        stateQueue.async(flags: .barrier) {
            task?.data.append(data)
        }
    }
}
