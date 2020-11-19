//
//  LoginResponse.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 09/10/2020.
//

import Foundation

struct LoginResponse: Decodable {
    let authToken: String
    
    enum CodingKeys: String, CodingKey {
        case authToken = "AuthToken"
    }
}
