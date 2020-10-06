//
//  SearchViewController.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            
            tableView.register(cellType: FeedTableCell.self)
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.prefetchDataSource = self
        }
    }
    
    //MARK: Properties
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = UIViewTitles.Search.searchPlaceholder
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
       return searchController
    }()
    
    private lazy var cancellables = Set<AnyCancellable>()
    
    var viewModel: SearchViewModel!
    
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar()
        initBindings()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchController.searchBar.resignFirstResponder()
    }
    
    //MARK: Helper Methods
    private func initNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        title = UIViewTitles.Search.headingTitle
    }
    
    private func initBindings() {
        NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .map( { ($0.object as? UITextField)?.text ?? "" } )
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] str in
                guard !str.isEmpty else { return }
                
                self?.viewModel.page = 1
                self?.viewModel.isAPIInProgress = false
                self?.viewModel.isLastPageReached = false
                
                self?.fetchData(query: str, isRemovePrevious: true)
            }
            .store(in: &cancellables)
        
        
        viewModel.$people
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                if let results = response?.hits {
                    if !results.isEmpty {
                        
                        let prevResultCount = self?.viewModel.hits.count ?? 0
                        self?.viewModel.hits.append(contentsOf: results)
                        let newResultCount = self?.viewModel.hits.count ?? 0
                        
                        let allHits = self?.viewModel.hits ?? []
                        let bookmarkedFeed: [HitModel] = DatabaseHandler().getAllBookmarks()
                        for hit in allHits {
                            let _ = bookmarkedFeed.map {
                                if hit.id == $0.id {
                                    hit.isBookmark = $0.isBookmark
                                }
                            }
                        }
                        
                        
                        if newResultCount > prevResultCount {
                            var indexPaths = [IndexPath]()
                            for count in prevResultCount..<newResultCount {
                                indexPaths.append(IndexPath(row: count, section: 0))
                            }
                            
                            self?.tableView.insertRows(at: indexPaths, with: .fade)
                        }
                        
                        self?.viewModel.isLastPageReached = false
                    } else {
                        self?.viewModel.isLastPageReached = true
                    }
                }
                
                if self?.viewModel.hits.isEmpty == true {
                    self?.tableView.setEmptyMessage(UIViewTitles.Feed.noItemMessage)
                } else {
                    self?.tableView.removeEmptyMessage()
                }
            }.store(in: &cancellables)
    }
    
    
    //MARK: Network Handlers
    func fetchData(query: String = "", isRemovePrevious: Bool = false) {
        viewModel.isAPIInProgress = true
        
        viewModel.fetchData(query: query)
            .mapError { [weak self] error -> Error in
                self?.viewModel.isAPIInProgress = false
                
                let alert = UIAlertController.getAlert(title: error.localizedDescription, message: nil)
                self?.present(alert, animated: true, completion: nil)
                return error
            }
            .sink(receiveCompletion: { _ in }) { [weak self] response in
                if isRemovePrevious {
                    self?.viewModel.hits.removeAll()
                    self?.tableView.reloadData()
                }
                
                self?.viewModel.isAPIInProgress = false
                self?.viewModel.page += 1
                
                self?.viewModel.people = response
            }
            .store(in: &cancellables)
    }
}


//MARK:- UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hits.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width + 105
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.isFetchMore(at: indexPath) else { return }
        fetchData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FeedTableCell.self, for: indexPath)
        
        if viewModel.hits.count > indexPath.row {
            cell.object = viewModel.hits[indexPath.row]
        }
        
        cell.subject
            .receive(on: DispatchQueue.main)
            .sink { action in
                switch action {
                case let .didTapBookmarkButton(model):
                    guard let model = model else { break }
                    
                    let bookmarkStatus = !model.isBookmark
                    
                    cell.setBookmarkStatus(bookmarkStatus)
                    
                    if model.isBookmark {
                        if let _ = DatabaseHandler().getBookmarkModel(for: model.id) {
                            DatabaseHandler().updateBookmarkStatusFor(id: model.id, status: bookmarkStatus)
                        } else {
                            DatabaseHandler().saveNewBookmark(model: model)
                        }
                    } else {
                        DatabaseHandler().updateBookmarkStatusFor(id: model.id, status: bookmarkStatus)
                    }
                }
            }
            .store(in: &cell.cancellables)
        
        return cell
    }
}


//MARK:- UITableViewDataSourcePrefetching
extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetchImages(at: indexPaths)
    }
}
