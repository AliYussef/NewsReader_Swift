//
//  ArticleViewModel.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 10/10/2020.
//

import Foundation
import Combine
import SwiftUI

class ArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var likedArticles: [Article] = []
    @Published var images = [String : Data]()
    @Published var LikedImages = [String : Data]()
    @Published var response: String = ""
    @Published var nextIdForLikedArticles: Int = -1 //used to check wether or not liked articles were fetched
    @Published var isLoadingPage = false
    private var nextId: Int = 0
    private var currentPage = 1
    private var canLoadMorePages = true
    var cancellationToken = Set<AnyCancellable>()
}

extension ArticleViewModel {
    
    func fetchArticles(completion: @escaping (Result<Response, RequestError>) -> Void) {
        NewsReaderAPI.shared.fetchArticles(requestType: .get, endpoint: .articles)?
            .sink(receiveCompletion: { result in
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
            }, receiveValue: { (response) in
                self.nextId = response.nextId
                self.articles = response.results
                self.fetchImages(of: self.articles)
                completion(.success(response))
            })
            .store(in: &cancellationToken)
        
    }
    
    func fetchMoreArticles(currentArticle article: Article?,completion: @escaping (Result<Response, RequestError>) -> Void) {
        
        guard let article = article else {
            fetchArticles {_ in}
            return
        }
        
        let thresholdIndex = articles.index(articles.endIndex, offsetBy: -5)
        if articles.firstIndex(where: { $0.id == article.id }) == thresholdIndex {
            
            guard !isLoadingPage && canLoadMorePages else {
                return
            }
            
            isLoadingPage = true
            
            NewsReaderAPI.shared.fetchNextArticlePatch(requestType: .get, endpoint: .nextArticlePatch(nextId))?
                .sink(receiveCompletion: { result in
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
                }, receiveValue: { (response) in
                    self.nextId = response.nextId
                    self.isLoadingPage = false
                    self.currentPage += 1
                    self.articles.append(contentsOf: response.results)
                    self.fetchImages(of: self.articles)
                    completion(.success(response))
                })
                .store(in: &cancellationToken)
            
        }
    }
    
    func fetchImages(of articles: [Article]) {
        articles.forEach { article in
            NewsReaderAPI.shared.getImage(for: article){ result in
                switch result {
                    case .success(let image):
                        if !self.images.keys.contains(article.image) {
                            self.images[article.image] = image
                        }
                    case .failure(let error):
                        switch error {
                            case .urlError(let urlError):
                                print(urlError)
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .genericError(let error):
                                print(error)
                        }
                }
            }
        }
    }
    
    func fetchLikedArticles(completion: @escaping (Result<Response, RequestError>) -> Void) {
        NewsReaderAPI.shared.fetchLikedArticles(requestType: .get, endpoint: .likedArticles)?
            .sink(receiveCompletion: { result in
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
            }, receiveValue: { result in
                self.likedArticles = result.results
                self.nextIdForLikedArticles = result.nextId
                self.fetchImages(of: self.likedArticles)
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
    func likeAnArticle(article: Article, completion: @escaping (Result<Data, RequestError>) -> Void) {
        
        NewsReaderAPI.shared.likeAnArticle(requestType: .put, endpoint: .likeArtcile(article.id))?
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                // since response is empty decoding error will always occur so execution needs to be done here
                                self.likedArticles.append(article)
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: { result in
                // just in case
                self.likedArticles.append(article)
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
    func unLikeAnArticle(article: Article, completion: @escaping (Result<Data, RequestError>) -> Void) {
        
        NewsReaderAPI.shared.likeAnArticle(requestType: .delete, endpoint: .unlikeArticle(article.id))?
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                // since response is empty decoding error will always occur so execution needs to be done here
                                self.likedArticles.removeAll(where: {$0.id == article.id})
                                self.articles.first(where: {$0 == article})?.isLiked.toggle()
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: { result in
                // just in case
                self.likedArticles.removeAll(where: {$0.id == article.id})
                self.articles.first(where: {$0 == article})?.isLiked.toggle()
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
}

