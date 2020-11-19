//
//  NewsReaderAPI.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 09/10/2020.
//

import Foundation
import Combine
import SwiftUI

class NewsReaderAPI: NewsReaderService {
    static let shared = NewsReaderAPI()
    private var cancellable = Set<AnyCancellable>()
    private init() {}
    
    func execute<ResponseType: Decodable>(request: URLRequest) -> AnyPublisher<ResponseType, Error>{
        URLSession.shared.dataTaskPublisher(for: request)
            .map({$0.data})
            .decode(type: ResponseType.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getImage(for article: Article, completion: @escaping (Result<Data, RequestError>) -> Void){
        let url = URL(string: article.image)!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map({$0.data})
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(.urlError(error)))
                }
            }) { (image) in
                completion(.success(image))
            }
            .store(in: &cancellable)
    }
    
    func fetchFeeds(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<FeedsResponse, Error>? {
        let urlString = BaseURL.url + endpoint.description
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        return execute(request: urlRequest)
    }
    
    func fetchArticles(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Response, Error>? {
        let urlString = BaseURL.url + endpoint.description
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        if UserViewModel.userVM.isAuthenticated {
            urlRequest.setValue(UserViewModel.userVM.accessToken, forHTTPHeaderField: "x-authtoken")
        }
        urlRequest.httpMethod = requestType.rawValue
        
        return execute(request: urlRequest)
    }
    
    func fetchNextArticlePatch(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Response, Error>?{
        let urlString = BaseURL.url + endpoint.description + "?count=20"
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        if UserViewModel.userVM.isAuthenticated {
            urlRequest.setValue(UserViewModel.userVM.accessToken, forHTTPHeaderField: "x-authtoken")
        }
        urlRequest.httpMethod = requestType.rawValue
        
        return execute(request: urlRequest)
    }
    
    func fetchLikedArticles(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Response, Error>?{
        let urlString = BaseURL.url + endpoint.description
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(UserViewModel.userVM.accessToken, forHTTPHeaderField: "x-authtoken")
        urlRequest.httpMethod = requestType.rawValue
        
        return execute(request: urlRequest)
    }
    
    func likeAnArticle(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Data, Error>?{
        let urlString = BaseURL.url + endpoint.description
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(UserViewModel.userVM.accessToken, forHTTPHeaderField: "x-authtoken")
        urlRequest.httpMethod = requestType.rawValue
        
        return execute(request: urlRequest)
    }
    
    func unLikeAnArticle(requestType: RequestType, endpoint: NewsReaderEndPoint) -> AnyPublisher<Data, Error>?{
        let urlString = BaseURL.url + endpoint.description
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(UserViewModel.userVM.accessToken, forHTTPHeaderField: "x-authtoken")
        urlRequest.httpMethod = requestType.rawValue
        
        return execute(request: urlRequest)
    }
    
    func register(requestType: RequestType, endpoint: NewsReaderEndPoint, user: User) -> AnyPublisher<RegisterResponse, Error>?{
        
        let urlString = BaseURL.url + endpoint.description
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = requestType.rawValue
        guard let body = try? JSONEncoder().encode(user) else { return nil }
        urlRequest.httpBody = body
        
        return execute(request: urlRequest)
    }
    
    func login(requestType: RequestType, endpoint: NewsReaderEndPoint, user: User) -> AnyPublisher<LoginResponse, Error>?{
        
        let urlString = BaseURL.url + endpoint.description
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = requestType.rawValue
        guard let body = try? JSONEncoder().encode(user) else { return nil }
        urlRequest.httpBody = body
        
        return execute(request: urlRequest)
    }
    
    
}
