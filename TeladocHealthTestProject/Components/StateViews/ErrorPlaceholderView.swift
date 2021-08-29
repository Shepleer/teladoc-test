//
//  LoadingErrorView.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 15/08/2021.
//

import UIKit

class ErrorPlaceholderView: UIView {
    struct Appearance {
        static let retryButtonText = "Retry?"
        static let viewSpacing: CGFloat = 5
    }
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle(Appearance.retryButtonText, for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.link.withAlphaComponent(0.3), for: .highlighted)
        button.setTitleColor(.link.withAlphaComponent(0.3), for: .selected)
        button.addTarget(self, action: #selector(retryButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    var onPress: (() -> Void)?
    
    init(withErrorText errorText: String) {
        super.init(frame: .zero)
        errorLabel.text = errorText
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        errorLabel.text = title
    }
}

private extension ErrorPlaceholderView {
    func setupSubviews() {
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(retryButton)
    
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc func retryButtonDidPressed() {
        onPress?()
    }
}
