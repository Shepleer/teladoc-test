//
//  ModulesFactory.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 15/08/2021.
//

import Foundation

protocol MainModulesFactory {
    func makeNumbersListModule() -> NumbersListModule
    func makeNumbersDetailsModule(with payload: NumberItem) -> NumbersDetailModule
}

class ModulesFactoryImpl: MainModulesFactory {
    func makeNumbersListModule() -> NumbersListModule {
        NumbersListModuleAssembly.makeModule()
    }
    
    func makeNumbersDetailsModule(with payload: NumberItem) -> NumbersDetailModule {
        NumbersDetailModuleAssembly.makeModule(with: payload)
    }
}
