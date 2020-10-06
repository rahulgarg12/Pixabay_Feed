//
//  HomeViewController.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var feedLabel: HeadingLabel! {
        didSet {
            feedLabel.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapFeedLabel))
            feedLabel.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet weak var bookmarkedLabel: HeadingLabel! {
        didSet {
            bookmarkedLabel.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapBookmarkedLabel))
            bookmarkedLabel.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet weak var sliderView: UIView!
    
    
    //MARK: Properties
    var pageViewController: UIPageViewController?

    lazy var bookmarkedViewController: BookmarkedViewController = {
        let vc = BookmarkedViewController(nibName: BookmarkedViewController.className, bundle: nil)
        vc.viewModel = BookmarkedViewModel()
        return vc
    }()
    
    lazy var feedViewController: FeedViewController = {
        let vc = FeedViewController(nibName: FeedViewController.className, bundle: nil)
        vc.viewModel = FeedViewModel()
        return vc
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = UIViewTitles.Home.searchPlaceholder
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
       return searchController
    }()
    
    private var searchBar: UISearchBar {
        return searchController.searchBar
    }

    
    //MARK: Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? UIPageViewController else { return }
            
        pageViewController = vc
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        setBookmarkedViewController()
    }

    //MARK: Selector Methods
    @objc private func didTapBookmarkedLabel() {
        setBookmarkedViewController()
    }
    
    @objc private func didTapFeedLabel() {
        setFeedViewController()
    }
    
    //MARK: Helper Methods
    private func setNavigationBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = UIColor.appBlack
        title = UIViewTitles.Home.headingTitle
    }
    
    private func setBookmarkedViewController() {
        pageViewController?.setViewControllers([bookmarkedViewController], direction: .reverse, animated: true, completion: nil)
        
        sliderView.frame.origin.x = 0
        
        bookmarkedLabel.textColor = UIColor.appBlack
        feedLabel.textColor = UIColor.appBlack?.withAlphaComponent(0.4)
    }
    
    private func setFeedViewController() {
        pageViewController?.setViewControllers([feedViewController], direction: .forward, animated: true, completion: nil)
        
        sliderView.frame.origin.x = view.bounds.width/2
        
        bookmarkedLabel.textColor = UIColor.appBlack?.withAlphaComponent(0.4)
        feedLabel.textColor = UIColor.appBlack
    }
}


//MARK:- UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let _ = viewController as? BookmarkedViewController {
            return nil
        } else {
            return bookmarkedViewController
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let _ = viewController as? BookmarkedViewController {
            return feedViewController
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if let _ = previousViewControllers.first as? BookmarkedViewController {
                setFeedViewController()
            } else {
                setBookmarkedViewController()
            }
        }
    }
}


//MARK:- UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let vc = SearchViewController(nibName: SearchViewController.className, bundle: nil)
        vc.viewModel = SearchViewModel()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: false)
        
        return false
    }
}
