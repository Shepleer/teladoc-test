//
//  NumbersDetailPresenter.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 27/08/2021.
//

import Foundation

protocol NumbersDetailPresenterToViewProtocol: AnyObject {
    func update(model: NumbersDetailItem)
}

class NumbersDetailPresenter {
    
    weak var view: NumbersDetailPresenterToViewProtocol?
    weak var moduleDelegate: NumbersDetailModuleDelegate?
    private var apiService: IApiService = ApiService()
    private let numberItem: NumberItem
    
    init(with model: NumberItem) {
        self.numberItem = model
    }
}

extension NumbersDetailPresenter: NumbersDetailViewToPresenterProtocol {
    func viewDidLoad() {
        fetchDetail()
    }
}

private extension NumbersDetailPresenter {
    func fetchDetail() {
        apiService.fetchDetails(with: numberItem.name) { [weak self] result in
            guard let model = try? result.get() else { return }
            self?.view?.update(model: model)
        }
    }
}
