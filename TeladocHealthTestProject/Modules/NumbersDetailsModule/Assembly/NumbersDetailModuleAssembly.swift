//
//  NumbersDetailModuleAssembly.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 27/08/2021.
//

import UIKit

class NumbersDetailModuleAssembly {
    static func makeModule(with payload: NumberItem) -> NumbersDetailModule {
        let view = NumbersDetailViewController()
        let presenter = NumbersDetailPresenter(with: payload)
        
        view.presenter = presenter
        presenter.view = view
        
        return NumbersDetailModuleImpl(view: view, presenter: presenter)
    }
}

protocol NumbersDetailModuleDelegate: AnyObject {}

protocol NumbersDetailModule: Module {
    func setup(delegate: NumbersDetailModuleDelegate)
}

private class NumbersDetailModuleImpl: NumbersDetailModule {
    private var view: UIViewController
    private var presenter: NumbersDetailPresenter
    
    init(view: NumbersDetailViewController, presenter: NumbersDetailPresenter) {
        self.view = view
        self.presenter = presenter
    }
    
    func toPresent() -> UIViewController {
        view
    }
    
    func setup(delegate: NumbersDetailModuleDelegate) {
        presenter.moduleDelegate = delegate
    }
}
