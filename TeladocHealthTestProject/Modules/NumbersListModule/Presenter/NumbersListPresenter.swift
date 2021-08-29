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
    private var apiService: IApiService = ApiService()

    private var dataSource: [NumberItem] = []
    private var activeLoadingCellsIndexPaths: Set<IndexPath> = []
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
        guard !activeLoadingCellsIndexPaths.contains(indexPath) else { return }
        activeLoadingCellsIndexPaths.insert(indexPath)
        apiService.loadImage(with: model.imageLink) { [weak self, model, indexPath] result in
            guard let self = self, let image = try? result.get() else {
                return
            }
            let resultModel = model.withImage(image)
            self.dataSource[indexPath.row] = resultModel
            self.view?.update(cellWith: resultModel, at: indexPath)
            self.activeLoadingCellsIndexPaths.remove(indexPath)
        }
    }
    
    func tableViewCell(cell: UITableViewCell, didSelectedAt indexPath: IndexPath) {
        moduleDelegate?.moveToDetailScreen(with: dataSource[indexPath.row])
    }
}
