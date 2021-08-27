//
//  NumbersResponseSchema.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 26/08/2021.
//

import Foundation

struct NumberResponseItem: Decodable {
    let name: String
    let image: String
}

extension NumberResponseItem {
    func convert() -> NumberItem {
        .init(name: name, imageLink: image, image: nil)
    }
}
