//
//  NumbersListModuleAssembly.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 15/08/2021.
//

import UIKit

class NumbersListModuleAssembly {
    static func makeModule() -> NumbersListModule {
        let view = NumbersListViewController()
        let presenter = NumbersListPresenter()
        
        view.presenter = presenter
        presenter.view = view
        
        return NumbersListModuleImpl(view: view, presenter: presenter)
    }
}

protocol NumbersListModuleDelegate: AnyObject {
    func moveToDetailScreen(with payload: NumberItem)
}

protocol NumbersListModule: Module {
    func setup(delegate: NumbersListModuleDelegate)
}

private class NumbersListModuleImpl: NumbersListModule {
    private var view: UIViewController
    private var presenter: NumbersListPresenter
    
    init(view: NumbersListViewController, presenter: NumbersListPresenter) {
        self.view = view
        self.presenter = presenter
    }
    
    func toPresent() -> UIViewController {
        view
    }
    
    func setup(delegate: NumbersListModuleDelegate) {
        presenter.moduleDelegate = delegate
    }
}
