//
//  RefreshScrollView.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 14/10/2020.
//

import UIKit
import SwiftUI

struct RefreshScrollView: UIViewRepresentable {
    var width: CGFloat
    var height: CGFloat
    let articleViewModel: ArticleViewModel
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl(sender:)), for: .valueChanged)
        let refreshVC = UIHostingController(rootView: NewsListView(articleViewModel: articleViewModel))
        refreshVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrollView.addSubview(refreshVC.view)
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, articleViewModel: articleViewModel)
    }
    
    class Coordinator: NSObject {
        var refreshScrollView: RefreshScrollView
        var articleViewModel: ArticleViewModel
        
        init(_ refreshScrollView: RefreshScrollView, articleViewModel: ArticleViewModel) {
            self.refreshScrollView = refreshScrollView
            self.articleViewModel = articleViewModel
        }
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            sender.endRefreshing()
            articleViewModel.fetchArticles { _ in}
        }
    }
}
