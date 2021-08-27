//
//  NumbersDetailViewController.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 27/08/2021.
//

import UIKit

protocol NumbersDetailViewToPresenterProtocol: AnyObject {
    func viewDidLoad()
}

class NumbersDetailViewController: UIViewController {
    struct Appearance {
        static let title = "Detail"
    }
    
    var presenter: NumbersDetailViewToPresenterProtocol?
    
    lazy var imageView = UIImageView()
    lazy var label = UILabel()
    
    override func viewDidLoad() {
        configureNavigationBar()
        configureUI()
        presenter?.viewDidLoad()
    }
}

extension NumbersDetailViewController: NumbersDetailPresenterToViewProtocol {
    func update(model: NumbersDetailItem) {
        imageView.image = model.image
        label.text = model.name
    }
}

private extension NumbersDetailViewController {
    func configureNavigationBar() {
        navigationItem.title = Appearance.title
        view.backgroundColor = .systemBackground
    }
    
    func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50)
        ])
    }
}
