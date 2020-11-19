//
//  NewsReaderService.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 09/10/2020.
//

import Foundation
import Combine

protocol NewsReaderService {
    func fetchFeeds(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<FeedsResponse, Error>?
    func fetchArticles(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Response, Error>?
    func fetchNextArticlePatch(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Response, Error>?
    func fetchLikedArticles(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Response, Error>?
    func likeAnArticle(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Data, Error>?
    func unLikeAnArticle(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Data, Error>?
    func register(requestType: RequestType, endpoint: NewsReaderEndPoint, user: User) -> AnyPublisher<RegisterResponse, Error>?
    func login(requestType: RequestType, endpoint: NewsReaderEndPoint, user: User) -> AnyPublisher<LoginResponse, Error>?
}

struct BaseURL {
    static let url = "https://inhollandbackend.azurewebsites.net/api/"
}

enum NewsReaderEndPoint: CustomStringConvertible{
    case feeds
    case articles
    case nextArticlePatch(Int)
    case likedArticles
    case likeArtcile(Int)
    case unlikeArticle(Int)
    case register
    case login
    
    var description: String {
        switch self {
            case .feeds:
                return "Feeds"
            case .articles:
                return "Articles"
            case .nextArticlePatch(let id):
                return "Articles/\(id)"
            case .likedArticles:
                return "Articles/liked"
            case .likeArtcile(let id):
                return "Articles/\(id)/like"
            case .unlikeArticle(let id):
                return "Articles/\(id)/like"
            case .register:
                return "Users/register"
            case .login:
                return "Users/login"
        }
    }
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum RequestError: Error {
    case urlError(URLError)
    case decodingError(DecodingError)
    case genericError(Error)
}
