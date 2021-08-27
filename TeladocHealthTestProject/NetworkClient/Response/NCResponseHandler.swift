//
//  NCParser.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 18/08/2021.
//

import Foundation

// initially there must be a logs & parsing part from a decodable model, but I there a couple of issues to think about
protocol ResponseHandler {
    func parce(response: NCResponse) throws -> Data
}

class NCHandler: ResponseHandler {
    func parce(response: NCResponse) throws -> Data {
        if let data = response.data {
            guard response.classification == .success else {
                throw NCError.networkError(.badStatusCode(response.statusCode))
            }
            printJSONString(from: data)
            return data
        } else if let error = response.error {
            // here should be error from url session
            throw NCError.networkError(.urlSessionError(error))
        }
        throw NCError.networkError(.emptyResponse)
    }
    
//    func decode<Model: Decodable>(_ data: Data) throws -> Model {
//        try JSONDecoder().decode(Model.self, from: data)
//    }
    
    func printJSONString(from data: Data) {
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = String(data: data, encoding: .utf8) else { return }
        print(prettyPrintedString)
    }
}
