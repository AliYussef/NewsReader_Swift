//
//  FeedViewModel.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 15/10/2020.
//

import Foundation
import Combine

class FeedViewModel: ObservableObject {
    @Published var feeds: [Feed] = []
    var cancellationToken = Set<AnyCancellable>()
    
    init() {
        fetchFeeds {_ in}
    }
}

extension FeedViewModel {
    func fetchFeeds(completion: @escaping (Result<FeedsResponse, RequestError>) -> Void) {
        NewsReaderAPI.shared.fetchFeeds(requestType: .get, endpoint: .feeds)?
            .sink(receiveCompletion: {result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: {result in
                self.feeds = result.feeds
                self.feeds.forEach { result in
                    print(result)
                }
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
}
