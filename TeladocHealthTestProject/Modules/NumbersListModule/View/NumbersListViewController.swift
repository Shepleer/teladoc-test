//
//  ViewController.swift
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 14/08/2021.
//

import UIKit

protocol NumbersListViewToPresenterProtocol: AnyObject {
    func viewDidLoad()
    func retryButtonDidPressed()
    func tableView(wantsToLoadContentForModel model: NumberItem, with indexPath: IndexPath)
    func tableViewCell(cell: UITableViewCell, didSelectedAt indexPath: IndexPath)
}

class NumbersListViewController: UIViewController {
    private struct Appearance {
        static let titleText = "Numbers List"
        static let loaderText = "Loading.."
        static let errorLabelText = "Something went wrong"
        static let cellIdentifier = "defaultCell"
    }
    
    var presenter: NumbersListViewToPresenterProtocol?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.frame = view.frame
        
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var loadingView = LoadingView(withLoaderText: Appearance.loaderText)
    lazy var errorView: ErrorPlaceholderView = {
        let errorView = ErrorPlaceholderView(withErrorText: Appearance.errorLabelText)
        errorView.onPress = { [unowned self] in
            self.presenter?.viewDidLoad()
        }
        return errorView
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        return refreshControl
    }()
    
    private var dataSource: [NumberItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        setupStateViews()
        setupTableView()
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedPath, animated: animated)
        }
    }
}

extension NumbersListViewController: NumbersListPresenterToViewProtocol {
    func update(cellWith model: NumberItem, at indexPath: IndexPath) {
        dataSource[indexPath.row] = model
//        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
//        tableView.endUpdates()
    }
    
    func update(dataSource: [NumberItem]) {
        self.dataSource = dataSource
        if let indexPath = tableView.indexPathForSelectedRow,
           let cell = tableView.cellForRow(at: indexPath) {
            presenter?.tableViewCell(cell: cell, didSelectedAt: indexPath)
        }
    }
    
    func update(state: LoadingState) {
        switch state {
            case .normal:
                focus(on: tableView)
            case .loading:
                loadingView.startAnimating()
                focus(on: loadingView)
            case .error(let errorText):
                errorView.setTitle(errorText)
                focus(on: errorView)
        }
    }
}

extension NumbersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Appearance.cellIdentifier)
        let model = dataSource[indexPath.row]
        cell.textLabel?.text = model.name
        if let image = model.image {
            cell.imageView?.image = image
        } else {
            presenter?.tableView(wantsToLoadContentForModel: model, with: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}

extension NumbersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundColor = .systemBlue
        presenter?.tableViewCell(cell: cell, didSelectedAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundColor = .systemBackground
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // workaround for default table view cell
        if tableView.indexPathForSelectedRow == indexPath {
            cell.backgroundColor = .systemBlue
        }
    }
}

private extension NumbersListViewController {
    func configureNavigationBar() {
        navigationItem.title = Appearance.titleText
    }
    
    func setupTableView() {
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupStateViews() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func focus(on view: UIView) {
        errorView.isHidden = view != errorView
        loadingView.isHidden = view != loadingView
        tableView.isHidden = view != tableView
        
        if self.view.contains(view) {
            self.view.bringSubviewToFront(view)
        }
    }
    
    @objc func refreshView() {
        // todo: add some boilerplate to refresh
    }
}
