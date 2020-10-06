//
//  BookmarkedViewController.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit
import Combine
import RealmSwift

final class BookmarkedViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            tableView.tableFooterView = UIView()
            
            tableView.register(cellType: FeedTableCell.self)
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: Properties
    private lazy var cancellables = Set<AnyCancellable>()
    
    var viewModel: BookmarkedViewModel!
    
    private var notificationToken: NotificationToken?
    
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.hits = DatabaseHandler().getAllBookmarks()
        initBindings()
    }
    
    //MARK: Helper Methods
    private func initBindings() {
        notificationToken = viewModel.hits?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                           with: .automatic)
                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                           with: .automatic)
                self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) },
                                           with: .automatic)
                self?.tableView.endUpdates()
                
            case .error(let error):
                print(error)
            }
            
            if self?.tableView.numberOfRows(inSection: 0) == 0 {
                self?.tableView.setEmptyMessage(UIViewTitles.Bookmark.noItemMessage)
            } else {
                self?.tableView.removeEmptyMessage()
            }
        }
        
        
        NotificationCenter.Publisher(center: .default, name: .didTapBookmark)
            .compactMap({ $0.object as? IdBookmarkModel })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self = self, let hits = self.viewModel.hits else { return }
                
                for (index, element) in hits.enumerated() {
                    if element.id == model.id {
                        DatabaseHandler().updateBookmarkStatusFor(id: model.id, status: model.bookmark)
                        
                        if self.tableView.numberOfSections > 0, self.tableView.numberOfRows(inSection: 0) > index {
                            let indexPath = IndexPath(row: index, section: 0)
                            self.tableView.beginUpdates()
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                            self.tableView.endUpdates()
                        }
                        
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
}


//MARK:- UITableViewDelegate, UITableViewDataSource
extension BookmarkedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FeedTableCell.self, for: indexPath)
        
        if let hits = viewModel.hits, hits.count > indexPath.row {
            cell.object = hits[indexPath.row]
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
                        if let realmModel = DatabaseHandler().getBookmarkModel(for: model.id) {
                            DatabaseHandler().updateBookmarkStatusFor(id: realmModel.id, status: true)
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
