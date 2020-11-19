//
//  NewsDetailView.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 11/10/2020.
//

import SwiftUI
import os

struct NewsDetailView: View {
    @ObservedObject var articleViewModel: ArticleViewModel
    let article: Article
    @State var isLiked: Bool = false
    var columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 0, alignment: .leading)
    ]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    if !articleViewModel.images.isEmpty {
                        if let image = articleViewModel.images[article.image] {
                            if let uiImage = UIImage(data: image){
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height: 400)
                                    .clipped()
                            }
                        }
                    }else{
                        if let uiImage = UIImage(systemName: "doc.append"){
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    HStack {
                        if let uiImage = UIImage(systemName: "calendar"){
                            Image(uiImage: uiImage)
                            
                        }
                        Text(DateConverter.convertDate(of: article))
                        
                    }.padding(3)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(10)
                    .position(x: 80, y: 370)
                    
                    
                    if UserViewModel.userVM.isAuthenticated {
                        HStack() {
                            if isLiked {
                                Button(action: {
                                    isLiked.toggle()
                                    ArticleHelper.unLikeAnArticle(article: article, articleViewModel: articleViewModel)
                                }, label: {Image(systemName: "heart.fill").foregroundColor(.red)})
                            } else {
                                Button(action: {
                                    isLiked.toggle()
                                    ArticleHelper.likeAnArticle(article: article, articleViewModel: articleViewModel)
                                }, label: {Image(systemName: "heart").foregroundColor(.black)})
                            }
                        }.padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .background(Color.white)
                        .cornerRadius(10)
                        .position(x: UIScreen.main.bounds.width - 30, y: 370)
                    }
                }
                
                Text(article.title)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .padding(10)
                
                Text(article.summary)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .padding(10)
                
                HStack {
                    Link(Localisation.readMoreLink,
                         destination: URL(string: article.url)!)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .foregroundColor(.white)
                        .background(Color.init("PrimaryColor"))
                        .cornerRadius(8.0)
                        .padding(10)
                }
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(article.categories){ category in
                        Text(category.name)
                            .font(.subheadline)
                            .frame(width: 100, height: 40, alignment: .center)
                            .foregroundColor(Color.white)
                            .background(Color.init("PrimaryDark"))
                            .cornerRadius(10)
                        
                    }
                }.padding(10)
            }
        }.onAppear{
            isLiked = article.isLiked
        }.navigationBarItems(trailing: Button(action: actionSheet) {
            Image(systemName: "square.and.arrow.up")
        })
        
        Spacer()
    }
    
    func actionSheet() {
        guard let data = URL(string: article.url) else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
}

