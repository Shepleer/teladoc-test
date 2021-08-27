//
//  ApiService.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 25/08/2021.
//

import UIKit

protocol IApiService {
    
}

struct RequestModelImpl: RequestModel {
    var customURL: URL?
    var host: String?
    var path: String
    var method: NCHTTPMethod = .get
    var headers: [String : String] = ["Content-Type": "application/json"]
    var parameters: [String: Any]? = nil
    var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData
    var retryPolicy: RetryPolicy = .noRetry
    var timeoutInterval: TimeInterval = 30
    
    init(path: String) {
        self.path = path
    }
    
    init(url: URL) {
        self.customURL = url
        self.path = ""
    }
}

class ApiService {
    enum Endpoint: String {
        case numbers = "/test/json.php"
    }
    
    private lazy var networkClient = NetworkClientAssembly.makeClient(
        with: .makeDefaultConfiguration(for: AppSettings.shared.backendUrl)
    )
    
    func fetchNumbers(completion: @escaping (Result<[NumberItem], NCError>) -> Void) {
        let requestModel = RequestModelImpl(path: Endpoint.numbers.rawValue)
        
        do {
            try networkClient.run(model: requestModel) { data, error in
                if let data = data {
                    guard let model = try? JSONDecoder().decode([NumberResponseItem].self, from: data) else {
                        DispatchQueue.main.async {
                            completion(.failure(.parsingError(.invalidResponseModel)))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(model.map { $0.convert() }))
                    }
                    return
                }
                if let error = error {
                    completion(.failure(error))
                }
            }
        } catch NCError.requestBuildError(let reason) {
            completion(.failure(NCError.requestBuildError(reason)))
        } catch {
            completion(.failure(.networkError(.emptyResponse)))
        }
    }
    
    func loadImage(with urlString: String, completion: @escaping (Result<UIImage, NCError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let requestModel = RequestModelImpl(url: url)
        
        do {
            try networkClient.run(model: requestModel) { data, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            
        }
    }
    
    func fetchDetails(with name: String, completion: @escaping (Result<NumbersDetailItem, NCError>) -> Void) {
        var requestModel = RequestModelImpl(path: Endpoint.numbers.rawValue)
        guard let dictionary = NumbersDetailRequestSchema(name: name).makeDictionary() else { return }
        requestModel.parameters = dictionary
        
        do {
            try networkClient.run(model: requestModel) { [weak self] data, error in
                guard let self = self,
                      let data = data,
                      let model = try? JSONDecoder().decode(NumberResponseItem.self, from: data)
                else { return }
                
                self.loadImage(with: model.image) { result in
                    guard let image = try? result.get() else {  return }
                    let resultModel = NumbersDetailItem(name: model.name, image: image)
                    DispatchQueue.main.async {
                        completion(.success(resultModel))
                    }
                }
            }
        } catch {
            
        }
    }
}
