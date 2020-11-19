//
//  RegisterResponse.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 09/10/2020.
//

import Foundation

struct RegisterResponse: Decodable {
    let success: Bool
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case message = "Message"
    }
}
