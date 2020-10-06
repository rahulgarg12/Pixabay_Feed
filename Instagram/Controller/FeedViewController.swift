//
//  FeedViewController.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit
import Combine

final class FeedViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            
            tableView.register(cellType: FeedTableCell.self)
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.prefetchDataSource = self
            
            tableView.refreshControl = refreshControl
        }
    }
    
    //MARK: Properties
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: UIViewTitles.Feed.refreshControlTitle)
        refreshControl.addTarget(self, action: #selector(refreshFreshData), for: .valueChanged)
        return refreshControl
    }()
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 200)
        return spinner
    }()
    
    private lazy var cancellables = Set<AnyCancellable>()
    
    var viewModel: FeedViewModel!
    
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBindings()
        
        showSpinner()
        fetchData()
    }
    
    
    //MARK: Helper Methods
    private func initBindings() {
        
        NotificationCenter.Publisher(center: .default, name: .didTapBookmark)
            .compactMap({ $0.object as? IdBookmarkModel })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self = self else { return }
                
                for (index, element) in self.viewModel.hits.enumerated() {
                    if element.id == model.id {
                        
                        DatabaseHandler().perform {
                            element.isBookmark = model.bookmark
                        }
                        
                        DatabaseHandler().updateBookmarkStatusFor(id: model.id, status: model.bookmark)
                        
                        if self.tableView.numberOfSections > 0, self.tableView.numberOfRows(inSection: 0) > index {
                            let indexPath = IndexPath(row: index, section: 0)
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                        
                        break
                    }
                }
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
                
                if self?.refreshControl.isRefreshing == true {
                    self?.refreshControl.endRefreshing()
                }
            }.store(in: &cancellables)
    }
    
    private func showSpinner() {
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    private func stopSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    
    //MARK: Network Handlers
    func fetchData(query: String = "", isRemovePrevious: Bool = false) {
        viewModel.isAPIInProgress = true
        
        viewModel.fetchData(query: query)
            .receive(on: DispatchQueue.main)
            .mapError { [weak self] error -> Error in
                self?.viewModel.isAPIInProgress = false
                self?.stopSpinner()
                
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
                
                self?.stopSpinner()
            }
            .store(in: &cancellables)
    }
    
    
    //MARK: Selector Methods
    @objc private func refreshFreshData() {
        if !viewModel.isAPIInProgress {
            viewModel.isLastPageReached = false
            viewModel.page = 1
            
            viewModel.hits.removeAll()
            fetchData(isRemovePrevious: true)
        }
    }
}


//MARK:- UITableViewDelegate, UITableViewDataSource
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
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
                    
                    if bookmarkStatus {
                        if let _ = DatabaseHandler().getBookmarkModel(for: model.id) {
                            DatabaseHandler().updateBookmarkStatusFor(id: model.id, status: bookmarkStatus)
                            DatabaseHandler().updateTimestampFor(id: model.id, timestamp: Date().timeIntervalSince1970)
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


//MARk:- UITableViewDataSourcePrefetching
extension FeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetchImages(at: indexPaths)
    }
}
