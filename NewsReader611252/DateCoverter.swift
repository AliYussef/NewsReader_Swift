//
//  DateCoverter.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 11/10/2020.
//

import Foundation

struct DateConverter {
    
    static func convertDate(of article: Article) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let publishDate = formatter.date(from: article.publishDate)
        formatter.dateFormat = "dd-MMM-yyyy"
        if let date = publishDate {
            return formatter.string(from: date)
        }
        return "Unkown Date"
    }
}
