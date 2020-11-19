//
//  FeedsResponse.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 15/10/2020.
//

import Foundation

struct FeedsResponse: Decodable {
    var feeds: [Feed] = []
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        if let count = container.count {
            for _ in 0..<(count) {
                let feed = try container.decode(Feed.self)
                feeds.append(feed)
            }
        }
    }
}

struct Feed: Identifiable, Decodable{
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}
