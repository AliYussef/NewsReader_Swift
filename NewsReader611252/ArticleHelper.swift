//
//  ArticleHelper.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 14/10/2020.
//

import Foundation
import os

struct ArticleHelper {
    
    static func unLikeAnArticle(article: Article, articleViewModel: ArticleViewModel) {
        article.isLiked.toggle()
        articleViewModel.unLikeAnArticle(article: article) { result in
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    switch error {
                        case .urlError(let urlError):
                            os_log("Url error", type: .error, urlError.localizedDescription)
                        case .decodingError(_):
                            break
                        case .genericError(let error):
                            os_log("Error", type: .error, error.localizedDescription)
                    }
            }
        }
    }
    
    static func likeAnArticle(article: Article, articleViewModel: ArticleViewModel) {
        article.isLiked.toggle()
        articleViewModel.likeAnArticle(article: article) { result in
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    switch error {
                        case .urlError(let urlError):
                            os_log("Url error", type: .error, urlError.localizedDescription)
                        case .decodingError(_):
                            break
                        case .genericError(let error):
                            os_log("Error", type: .error, error.localizedDescription)
                    }
            }
        }
    }
}
