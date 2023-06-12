//
//  HomeViewController.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import UIKit

class PostListViewController: UIViewController, Alertable {

    // MARK: Lifecycle
    private var viewModel: PostsListViewModel!
    private var isSearching = false


    private var nextPageLoadingSpinner: UIActivityIndicatorView?

    static func create(with viewModel: PostsListViewModel) -> PostListViewController {
        let view = PostListViewController()
        view.viewModel = viewModel
        return view
    }

    // MARK: UI Elements

    private var searchController = UISearchController(searchResultsController: nil)

    lazy private var postListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostItemCell.self, forCellReuseIdentifier: "MyCell")
        tableView.estimatedRowHeight = 70
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.backgroundColor = UIColor(named: "primary-color")
        tableView.isHidden = true
        return tableView
    }()

    lazy private var showErrorNotFoundView: ItemCarousel = {
        let view = ItemCarousel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()

    // MARK: View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        configurationIconBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.didLoadPosts()
        bind(to: viewModel!)
        setUpViews()
        setupConstraints()
        setupSearchController()
    }

    // MARK: Layout

    private func setUpViews() {
        view.addSubview(postListTableView)
        view.addSubview(showErrorNotFoundView)
    }

    private func configurationIconBar() {
        self.navigationItem.hidesBackButton = true

        if let icon = UIImage(named: Image.settingsIcon)?.withRenderingMode(.alwaysOriginal) {
            let newBackButton = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(showPermissionList))
            self.navigationItem.leftBarButtonItem = newBackButton
        }
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            postListTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            postListTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            postListTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            postListTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            showErrorNotFoundView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            showErrorNotFoundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            showErrorNotFoundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            showErrorNotFoundView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    // MARK: User Interaction

    @objc private func showPermissionList() {
        viewModel.didShowPermission()
    }
    
    private func bind(to viewModel: PostsListViewModel) {

        viewModel.items.observe(on: self) { [weak self] _ in
            guard let self = self else {return}
            self.updateItems()
        }
        viewModel.error.observe(on: self) {  [weak self] in self?.showError($0)
        }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }

        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0)}
        
        viewModel.foundSearch.observe(on: self, observerBlock: {[weak self] in self?.updatedFoundSearch($0)})
        
        viewModel.isSearching.observe(on: self, observerBlock: {[weak self] in self?.updatedStatusSearch($0)})
        
    }
    
    private func updatedStatusSearch(_ status: Bool) {
        isSearching = status
    }

    private func updatedFoundSearch(_ status: Bool) {
        if status {
            showErrorNotFoundView.isHidden = true
            postListTableView.isHidden = false
        } else {
            showErrorNotFoundView.isHidden = false
            postListTableView.isHidden = true
        }
    }

    private func updateItems() {
        DispatchQueue.main.async {
            self.postListTableView.reloadData()
        }
    }

    private func updateLoading(_ loading: PostsListViewModelLoading?) {
        LoadingView.hide()

        switch loading {
        case .fullScreen:
            LoadingView.show()
        case .nextPage: postListTableView.isHidden = false
        case .none:
            postListTableView.isHidden = viewModel!.isEmpty
        }

        updatedLoadingNextPage(loading)
    }

    private func updatedLoadingNextPage(_ loading: PostsListViewModelLoading?) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: postListTableView.frame.width, height: 44))
            postListTableView.tableFooterView = nextPageLoadingSpinner
        case .fullScreen, .none:
            postListTableView.tableFooterView = nil
        }
    }

    private func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        addScreenErrorNetwork()
    }
    
    private func addScreenErrorNetwork() {
        let errorView = ErrorNetworkViewController()
      //  self.navigationController?.pushViewController(errorView, animated: true)
        errorView.delegate = self
        errorView.modalPresentationStyle = .fullScreen
        present(errorView, animated: false)
    }

}

//MARK: SearchBar
extension PostListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel?.didSearch(query: searchText)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel?.didSearch(query: searchText)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if isSearching {
            return false
        }
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.didCancelSearch()
    }

    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.searchTextField.textColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
}

//MARK: TableView
extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! PostItemCell
        let data = viewModel.items.value[indexPath.row].data!
        cell.selectionStyle = .none
        cell.fill(with: data)

        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }

        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

//MARK: Error network
extension PostListViewController: ErrorNetworkProtocol {
    func retryRed() {
        viewModel.didLoadPosts()
    }
}
