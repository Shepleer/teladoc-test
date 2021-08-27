//
//  NCConfiguration.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 17/08/2021.
//

import Foundation

struct NCSessionConfiguration {
    let host: String
    let defaultHeaders: [String: String]
    
    init(host: String, defaultHeaders: [String: String] = [:]) {
        self.host = host
        self.defaultHeaders = defaultHeaders
    }
    
    static func makeDefaultConfiguration(for host: String) -> NCSessionConfiguration {
        NCSessionConfiguration(host: host, defaultHeaders: ["Content-Type": "application/json; charset=utf-8"])
    }
}
