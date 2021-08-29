//
//  ApiService.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 25/08/2021.
//

import UIKit

protocol IApiService {
    func fetchNumbers(completion: @escaping (Result<[NumberItem], NCError>) -> Void)
    func loadImage(with urlString: String, completion: @escaping (Result<UIImage, NCError>) -> Void)
    func fetchDetails(with name: String, completion: @escaping (Result<NumbersDetailItem, NCError>) -> Void)
}

class ApiService: IApiService {
    enum Endpoint: String {
        case numbers = "/test/json.php"
    }
    
    private lazy var networkClient = NetworkClientAssembly.makeClient(
        with: .makeDefaultConfiguration(for: AppSettings.shared.backendUrl)
    )
    
    func fetchNumbers(completion: @escaping (Result<[NumberItem], NCError>) -> Void) {
        let requestModel = DefaultRequest(path: Endpoint.numbers.rawValue)
        
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
            completion(.failure(.requestBuildError(.unknownError)))
        }
    }
    
    func loadImage(with urlString: String, completion: @escaping (Result<UIImage, NCError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let requestModel = DefaultRequest(url: url)
        
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
        } catch NCError.requestBuildError(let reason) {
            completion(.failure(.requestBuildError(reason)))
        } catch {
            completion(.failure(.requestBuildError(.unknownError)))
        }
    }
    
    func fetchDetails(with name: String, completion: @escaping (Result<NumbersDetailItem, NCError>) -> Void) {
        var requestModel = DefaultRequest(path: Endpoint.numbers.rawValue)
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
