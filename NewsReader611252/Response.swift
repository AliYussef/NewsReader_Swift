//
//  Response.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 09/10/2020.
//

import Foundation

struct Response: Decodable {
    let results: [Article]
    let nextId: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "Results"
        case nextId = "NextId"
    }
}
