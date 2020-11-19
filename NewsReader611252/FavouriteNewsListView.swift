//
//  FavouriteNewsListView.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 13/10/2020.
//

import SwiftUI
import os

struct FavouriteNewsListView: View {
    @ObservedObject var articleViewModel: ArticleViewModel
    
    var body: some View {
        if UserViewModel.userVM.isAuthenticated {
            
            if articleViewModel.nextIdForLikedArticles == -1 {
                ProgressView(Localisation.loadingFavouriteList)
                    .onAppear {
                        articleViewModel.fetchLikedArticles { result in
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
            } else if (articleViewModel.nextIdForLikedArticles != -1 && !articleViewModel.likedArticles.isEmpty){
                ScrollView {
                    LazyVStack {
                        ForEach(articleViewModel.likedArticles) { article in
                            NavigationLink(destination: NewsDetailView(articleViewModel: articleViewModel, article: article).navigationTitle(Localisation.navTextNewsDetails)) {
                                NewsCellView(articleViewModel: articleViewModel, article: article)
                            }.foregroundColor(.black)
                        }
                    }
                }
            } else {
                Text(Localisation.favouriteListEmpty)
            }
        } else {
            Text(Localisation.loginToSeeFavouriteList)
            Image(systemName: "face.smiling.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.yellow)
        }
        
    }
}

