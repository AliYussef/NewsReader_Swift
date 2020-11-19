//
//  NewsCellView.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 11/10/2020.
//

import SwiftUI

struct NewsCellView: View {
    @ObservedObject var articleViewModel: ArticleViewModel
    @State var isLiked: Bool = false
    let article: Article
    
    var body: some View {
        VStack{
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                if let image = articleViewModel.images[article.image] {
                    if let uiImage = UIImage(data: image){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 30, height: 200, alignment: .center)
                            .clipped()
                            .cornerRadius(20)
                            
                    }
                }else{
                    Image(systemName: "doc.append")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 200, alignment: .center)
                        .clipped()
                        .cornerRadius(20)
                }
                HStack() {
                    if let uiImage = UIImage(systemName: "calendar"){
                        Image(uiImage: uiImage)
                    }
                    Text(DateConverter.convertDate(of: article))
                    
                }.padding(3)
                .background(Color.white)
                .cornerRadius(10)
                .padding(10)
                .position(x: 100, y: 170)
                
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
                            }, label: {Image(systemName: "heart")})
                        }
                    }.padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .background(Color.white)
                    .cornerRadius(10)
                    .position(x: UIScreen.main.bounds.width - 50, y: 170)
                }
            }
            
            Text(article.title)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .padding()
            
        }.onAppear {
            isLiked = article.isLiked
        }
    }
    
    
}
