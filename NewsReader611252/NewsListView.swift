//
//  NewsListView.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 11/10/2020.
//

import SwiftUI
import os

struct NewsListView: View {
    @ObservedObject var articleViewModel: ArticleViewModel
    @StateObject var feedViewModel = FeedViewModel()
    @State var feed: Int = 0
    @State private var selected = 0
    
    var body: some View {
        if !feedViewModel.feeds.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Picker(selection: $selected, label: Text("Filter").foregroundColor(.black)) {
                        Text("All").tag(0)
                        ForEach(feedViewModel.feeds) { feed in
                            Text(feed.name).tag(feed.id)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                }.padding(10)
            }
            Spacer()
        }
        if articleViewModel.articles.isEmpty {
            ProgressView(Localisation.loadingNews)
                .onAppear {
                    articleViewModel.fetchArticles { result in
                        switch result {
                            case .success(_):
                                break
                            case .failure(let error):
                                switch error {
                                    case .urlError(let urlError):
                                        os_log("Url error", type: .error, urlError.localizedDescription)
                                    case .decodingError(let decodingerror):
                                        os_log("Decoding error", type: .error, decodingerror.localizedDescription)
                                    case .genericError(let error):
                                        os_log("Error", type: .error, error.localizedDescription)
                                }
                        }
                    }
                }
            Spacer()
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(articleViewModel.articles.filter({
                        if selected > 0 {
                            return $0.feed == selected
                        } else {
                            return  $0.feed <= feedViewModel.feeds.count
                        }
                    })) { article in
                        NavigationLink(destination: NewsDetailView(articleViewModel: articleViewModel, article: article).navigationTitle(Localisation.navTextNewsDetails)) {
                            NewsCellView(articleViewModel: articleViewModel, article: article)
                                .onAppear {
                                    articleViewModel.fetchMoreArticles(currentArticle: article) { result in
                                        switch result {
                                            case .success(_):
                                                break
                                            case .failure(let error):
                                                switch error {
                                                    case .urlError(let urlError):
                                                        os_log("Url error", type: .error, urlError.localizedDescription)
                                                    case .decodingError(let decodingerror):
                                                        os_log("Decoding error", type: .error, decodingerror.localizedDescription)
                                                    case .genericError(let error):
                                                        os_log("Error", type: .error, error.localizedDescription)
                                                }
                                        }
                                    }
                                }
                        }
                        .foregroundColor(.black)
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if articleViewModel.isLoadingPage {
                        ProgressView()
                    }
                }
            }
        }
    }
}

