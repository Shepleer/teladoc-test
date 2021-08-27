//
//  LoadingState.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 16/08/2021.
//

import Foundation

enum LoadingState {
    case normal
    case loading
    case error(_ errorText: String)
}
