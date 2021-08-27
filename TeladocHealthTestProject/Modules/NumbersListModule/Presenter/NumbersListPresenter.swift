//
//  NumbersListPresenter.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 15/08/2021.
//

import UIKit

protocol NumbersListPresenterToViewProtocol: AnyObject {
    func update(state: LoadingState)
    func update(dataSource: [NumberItem])
    func update(cellWith model: NumberItem, at: IndexPath)
}

class NumbersListPresenter {
    weak var view: NumbersListPresenterToViewProtocol?
    weak var moduleDelegate: NumbersListModuleDelegate?
    private var apiService = ApiService()

    private var dataSource: [NumberItem] = []
    private var activeLoadingImagesUrls: Set<String> = []
}

extension NumbersListPresenter: NumbersListViewToPresenterProtocol {
    func viewDidLoad() {
        view?.update(state: .loading)
        apiService.fetchNumbers { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let numbers):
                    self.dataSource = numbers
                    self.view?.update(dataSource: numbers)
                    self.view?.update(state: .normal)
                case .failure(let error):
                    self.view?.update(state: .error(error.description))
            }
        }
    }
    
    func retryButtonDidPressed() {
        viewDidLoad()
    }
    
    func tableView(wantsToLoadContentForModel model: NumberItem, with indexPath: IndexPath) {
        guard !activeLoadingImagesUrls.contains(model.imageLink) else { return }
        activeLoadingImagesUrls.insert(model.imageLink)
        apiService.loadImage(with: model.imageLink) { [weak self, model, indexPath] result in
            guard let self = self, let image = try? result.get() else {
                return
            }
            let resultModel = model.withImage(image)
            self.dataSource[indexPath.row] = resultModel
            self.view?.update(cellWith: resultModel, at: indexPath)
            self.activeLoadingImagesUrls.remove(model.imageLink)
        }
    }
    
    func tableViewCell(cell: UITableViewCell, didSelectedAt indexPath: IndexPath) {
        moduleDelegate?.moveToDetailScreen(with: dataSource[indexPath.row])
    }
}
