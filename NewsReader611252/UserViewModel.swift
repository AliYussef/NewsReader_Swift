//
//  UserViewModel.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 12/10/2020.
//

import Foundation
import Combine
import KeychainAccess

final class UserViewModel: ObservableObject {
    static let userVM = UserViewModel()
    @Published var isAuthenticated: Bool = false
    var cancellationToken = Set<AnyCancellable>()
    private let keychain = Keychain()
    private var accessTokenKeyChainKey = "accessToken"
    
    var accessToken: String? {
        get {
            try? keychain.get(accessTokenKeyChainKey)
        }
        set(newValue) {
            guard let accessToken = newValue else {
                try? keychain.remove(accessTokenKeyChainKey)
                isAuthenticated = false
                return
            }
            try? keychain.set(accessToken, key: accessTokenKeyChainKey)
            isAuthenticated = true
        }
    }
    
    init() {
        isAuthenticated = accessToken != nil
    }
}

extension UserViewModel {
    
    func login(for user: User, completion: @escaping (Result<LoginResponse, RequestError>) -> Void) {
        NewsReaderAPI.shared.login(requestType: .post, endpoint: .login, user: user)?
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case.failure(let error):
                        switch error {
                            case let urlError as URLError:
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                completion(.failure(.genericError(error)))
                        }
                }
            } , receiveValue: { result in
                self.accessToken = result.authToken
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
    func register(user: User, completion: @escaping (Result<RegisterResponse, RequestError>) -> Void) {
        NewsReaderAPI.shared.register(requestType: .post, endpoint: .register, user: user)?
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
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
    func logout() {
        accessToken = nil
    }
}
