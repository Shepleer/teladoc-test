//
//  LoadingView.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 15/08/2021.
//

import UIKit

class LoadingView: UIView {
    private struct Appearance {
        static let stackViewSpacing: CGFloat = 5
    }
    
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(withLoaderText text: String) {
        super.init(frame: .zero)
        loadingLabel.text = text
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let indicatorSize = activityIndicator.intrinsicContentSize
        let labelSize = loadingLabel.intrinsicContentSize
        
        let height = indicatorSize.height + labelSize.height + Appearance.stackViewSpacing
        let width = labelSize.width
        
        return CGSize(width: width, height: height)
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
}

private extension LoadingView {
    func setupSubviews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(loadingLabel)

        addSubview(stackView)
        
        stackView.frame = CGRect(origin: .zero, size: intrinsicContentSize)
    }
}
