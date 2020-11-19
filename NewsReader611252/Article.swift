//
//  Article.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 09/10/2020.
//

import Foundation
import SwiftUI

class Article: Decodable, Identifiable, Equatable{
    
    let id: Int
    let feed: Int
    let title: String
    let summary: String
    var publishDate: String
    let image: String
    let url: String
    let related: [String]
    let categories: [Category]
    var isLiked: Bool
    
    enum CodingKeys: String, CodingKey{
        case id = "Id"
        case feed = "Feed"
        case title = "Title"
        case summary = "Summary"
        case publishDate = "PublishDate"
        case image = "Image"
        case url = "Url"
        case related = "Related"
        case categories = "Categories"
        case isLiked = "IsLiked"
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Category: Decodable, Identifiable{
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}
