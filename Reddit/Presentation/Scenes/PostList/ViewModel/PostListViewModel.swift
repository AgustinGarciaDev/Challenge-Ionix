//
//  HomeViewModel.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import Foundation

struct PostsListViewModelActions {
    let showPermissions: () -> Void
}

enum PostsListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol PostsListViewModelInput {
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func didLoadPosts()
    func didShowPermission()
}

protocol PostsListViewModelOutput {
    var items: Observable<[PostList]> { get }
    var error: Observable<String> { get }
    var query: Observable<String> { get }
    var foundSearch: Observable<Bool> { get }
    var isSearching: Observable<Bool> { get }
    var isEmpty: Bool { get }
    var errorTitle: String { get }
    var loading: Observable<PostsListViewModelLoading?> { get }
}

protocol PostsListViewModel: PostsListViewModelInput, PostsListViewModelOutput {}

class DefaultPostListViewModel: PostsListViewModel {
    let foundSearch: Observable<Bool> = Observable(true)
    let isSearching: Observable<Bool> = Observable(false)
    let items: Observable<[PostList]> =  Observable([])
    let error: Observable<String> = Observable("")
    let query: Observable<String> = Observable("")
    let loading: Observable<PostsListViewModelLoading?> = Observable(.none)
    var isEmpty: Bool { return items.value.isEmpty}
    let errorTitle: String = ""

    private let loadPostUseCase: LoadPostUseCase
    private let searchPostsUseCase: SearchPostsUseCase
    private let actions: PostsListViewModelActions?

    private var postLoadTask: Cancellable? { willSet { postLoadTask?.cancel() } }
    private var nextPage: String = ""
    private var postsList: [PostList] = []

    init(loadPostUseCase: LoadPostUseCase,
         searchPostsUseCase: SearchPostsUseCase,
         actions: PostsListViewModelActions? = nil) {
        self.loadPostUseCase = loadPostUseCase
        self.actions = actions
        self.searchPostsUseCase = searchPostsUseCase
    }

    private func loadPosts(loading: PostsListViewModelLoading) {
        self.loading.value = loading

        guard nextPage != "There is no next page." else {
              self.loading.value = .none
              return
        }

        postLoadTask = loadPostUseCase.execute(nexPage: nextPage, completion: { [weak self] result in
            guard let self = self else {return}

            switch result {
            case .success(let posts):
                self.appendPage(posts)
            case .failure(let error):
                self.handle(error: error)
            }
            self.loading.value = .none
            isSearching.value = false
        })
    }

    private func searchPosts(loading: PostsListViewModelLoading, request: SearchRequest) {
        self.loading.value = loading

        postLoadTask = searchPostsUseCase.execute(requestValue: request, completion: { [weak self] result in
            guard let self = self else {return}

            switch result {
            case .success(let posts):
                self.searchResult(posts)
            case .failure(let error):
                self.handle(error: error)
            }
            self.loading.value = .none
            isSearching.value = false
        })
    }

    private func searchResult(_ informationPosts: PageInformation) {
        postsList.removeAll()

        guard !informationPosts.data.children.isEmpty else {
            foundSearch.value = false
            return
        }
        
        appendPage(informationPosts)
    }

    private func appendPage(_ informationPosts: PageInformation) {
        nextPage = informationPosts.data.after ?? "There is no next page."
        let posts = informationPosts.data.children
        let filteredPosts = posts.filter { postList in
            guard let postData = postList.data else {
                return false
            }
            return postData.postHint == "image" && postData.linkFlairText == "Shitposting"
        }

        postsList = postsList
            .filter { !filteredPosts.contains($0) }
            + filteredPosts

        if postsList.isEmpty {
            print(items.value)
            if nextPage !=  "There is no next page." {
                didLoadNextPage()
            } else {
                foundSearch.value = false
            }
        } else {
            foundSearch.value = true
            items.value = postsList
        }
    }

    private func handle(error: Error) {
        print(error.localizedDescription)
        self.error.value = error.isInternetConnectionError ? "No internet connection" : "Failed loading post"
    }
}

extension DefaultPostListViewModel {
    func didLoadPosts() {
        loadPosts(loading: .fullScreen)
    }

    func didLoadNextPage() {
        loadPosts(loading: .nextPage)
    }

    func didSearch(query: String) {
        let request = SearchRequest(search: query)
        isSearching.value = true
        searchPosts(loading: .fullScreen, request: request)
    }

    func didCancelSearch() {
        nextPage = ""
        foundSearch.value = true
        loadPosts(loading: .fullScreen)
    }

    func didShowPermission() {
        actions?.showPermissions()
    }
}
