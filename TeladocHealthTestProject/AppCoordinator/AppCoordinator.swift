//
//  AppCoordinator.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 14/08/2021.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow
    static let shared = AppCoordinator()
    
    private var factory: MainModulesFactory = ModulesFactoryImpl()
    private lazy var containerVC: UISplitViewController = {
        let splitVC = UISplitViewController(style: .doubleColumn)
        splitVC.preferredSplitBehavior = .tile
        splitVC.preferredPrimaryColumnWidthFraction = 0.5
        splitVC.preferredDisplayMode = .oneBesideSecondary
        splitVC.maximumPrimaryColumnWidth = UIScreen.main.bounds.height / 2
        splitVC.delegate = self
        splitVC.view.backgroundColor = .systemGray
        return splitVC
    }()
    
    private init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func start() {
        moveToMainScreen()
    }
}

extension AppCoordinator: UISplitViewControllerDelegate {

}

extension AppCoordinator: NumbersListModuleDelegate {
    func moveToDetailScreen(with payload: NumberItem) {
        let detailModule = factory.makeNumbersDetailsModule(with: payload)
        detailModule.setup(delegate: self)
        let navigation = UINavigationController(rootViewController: detailModule.toPresent())
        containerVC.showDetailViewController(navigation, sender: self)
    }
}

extension AppCoordinator: NumbersDetailModuleDelegate {
    
}

private extension AppCoordinator {
    func moveToMainScreen() {
        let numbersListModule = factory.makeNumbersListModule()
        numbersListModule.setup(delegate: self)
        
        containerVC.setViewController(numbersListModule.toPresent(), for: .primary)
        
        window.rootViewController = containerVC
        window.makeKeyAndVisible()
    }
}
