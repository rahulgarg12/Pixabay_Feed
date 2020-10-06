//
//  FeedViewModel.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import Foundation
import Combine

final class FeedViewModel {
    lazy var isLastPageReached = false
    lazy var isAPIInProgress = false
    var page = 1
    
    @Published var people: SearchResponseModel?
    var hits = [HitModel]()
    
    
    //MARK: Network Handlers
    func fetchData(query: String = "") -> AnyPublisher<SearchResponseModel, Error> {
        let searchParams = NSMutableDictionary()
        searchParams[Network.APIKey.key] = Network.APIConstants.pixabayAPIKey
        searchParams[Network.APIKey.query] = query
        searchParams[Network.APIKey.page] = page
        
        guard var urlComponents = URLComponents(string: APIs.people) else {
            let error = URLError(.badURL)
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let queryParams: [URLQueryItem]? = searchParams.compactMap {
            guard let key = $0.key as? String else { return nil }
            return URLQueryItem(name: key, value: "\($0.value)")
        }
        urlComponents.queryItems = queryParams
        
        guard let url = urlComponents.url else {
            let error = URLError(.badURL)
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return NetworkHandler().run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    
    func isFetchMore(at indexPath: IndexPath) -> Bool {
        if !hits.isEmpty,
            hits.count - 5 == indexPath.item,
            isAPIInProgress == false,
            isLastPageReached == false {
            return true
        } else {
            return false
        }
    }
    
    func prefetchImages(at indexPaths: [IndexPath]) {
        let urls: [String] = indexPaths.compactMap {
            guard hits.count > $0.item else { return nil}
            return hits[$0.item].largeImageURL
        }
        ImageHandler().prefetch(urls: urls)
    }
}
