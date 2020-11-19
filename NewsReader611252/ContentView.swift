//
//  ContentView.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 09/10/2020.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userViewModel = UserViewModel.userVM
    @StateObject var articleViewModel = ArticleViewModel()
    
    
    var body: some View {
        
        if userViewModel.isAuthenticated {
            TabView {
                NavigationView {
                    GeometryReader { geometry in
                        RefreshScrollView(width: geometry.size.width, height: geometry.size.height, articleViewModel: articleViewModel)
                    }
                    .navigationBarItems(leading: Button(action: {
                        self.doOnceLoggedout()
                    }, label: {VStack{ Image(systemName: "square.and.arrow.up"); Text(Localisation.logoutTextBtn).font(.caption)}}), trailing: Text(""))
                    .navigationTitle(Localisation.navTextHome)
                }.navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(Localisation.tabBarHome)
                }
                NavigationView {
                    FavouriteNewsListView(articleViewModel: articleViewModel)
                        .navigationBarItems(leading: Button(action:  {
                            self.doOnceLoggedout()
                        }, label: {VStack{ Image(systemName: "square.and.arrow.up"); Text(Localisation.logoutTextBtn).font(.caption)}}), trailing: Text(""))
                        .navigationTitle(Localisation.navTextFavourite)
                }.navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text(Localisation.tabBarFavourite)
                }
            }
        } else if !userViewModel.isAuthenticated{
            
            TabView {
                NavigationView {
                    GeometryReader { geometry in
                        RefreshScrollView(width: geometry.size.width, height: geometry.size.height, articleViewModel: articleViewModel)
                    }
                    .navigationBarItems(trailing: NavigationLink(destination: LoginView(articleViewModel: articleViewModel), label:{VStack{ Image(systemName: "person.fill"); Text(Localisation.loginTextBtn).font(.caption)}}))
                    .navigationTitle(Localisation.navTextHome)
                }.navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(Localisation.tabBarHome)
                }
                NavigationView {
                    FavouriteNewsListView(articleViewModel: articleViewModel)
                        .navigationBarItems(trailing: NavigationLink(destination: LoginView(articleViewModel: articleViewModel), label:{VStack{ Image(systemName: "person.fill"); Text(Localisation.loginTextBtn).font(.caption)}}))
                        .navigationTitle(Localisation.navTextFavourite)
                }.navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text(Localisation.tabBarFavourite)
                }
            }
        }
        
    }
    
    func doOnceLoggedout() {
        self.userViewModel.logout()
        self.articleViewModel.likedArticles.removeAll()
        self.articleViewModel.nextIdForLikedArticles = -1
        self.articleViewModel.articles.removeAll()
        self.articleViewModel.fetchArticles {_ in}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
