//
//  NumberItem.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 27/08/2021.
//

import UIKit

struct NumberItem {
    let name: String
    let imageLink: String
    let image: UIImage?
    
    func withImage(_ image: UIImage) -> Self {
        .init(name: name, imageLink: imageLink, image: image)
    }
}
