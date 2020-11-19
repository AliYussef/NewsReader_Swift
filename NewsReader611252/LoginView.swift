//
//  LoginView.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 12/10/2020.
//

import SwiftUI
import os

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var articleViewModel: ArticleViewModel
    @State var username: String = ""
    @State var password: String = ""
    @State var isTryingToLogin: Bool = false
    @State var isRequestErrorViewPresented: Bool = false
    
    var body: some View {
        VStack {
            if isTryingToLogin {
                ProgressView(Localisation.tryingToLogin)
            } else {
                
                TextField(Localisation.enterUsernameText, text: $username)
                    .padding()
                    .border(Color.black.opacity(0.2), width: 1)
                    .cornerRadius(3.0)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                SecureField(Localisation.enterPasswordText, text: $password)
                    .padding()
                    .border(Color.black.opacity(0.2), width: 1)
                    .cornerRadius(3.0)
                Button(action: {
                    isTryingToLogin = true
                    UserViewModel.userVM.login(for: User(username: username, password: password)) { result in
                        switch result {
                            case .success(_):
                                self.articleViewModel.fetchArticles {_ in}
                                self.presentationMode.wrappedValue.dismiss()
                            case.failure(let error):
                                self.isRequestErrorViewPresented = true
                                switch error {
                                    case .urlError(let urlError):
                                        os_log("Url error", type: .error, urlError.localizedDescription)
                                    case .decodingError(let decodingerror):
                                        os_log("Decoding error", type: .error, decodingerror.localizedDescription)
                                    case .genericError(let error):
                                        os_log("Error", type: .error, error.localizedDescription)
                                }
                        }
                        self.isTryingToLogin = false
                    }
                }, label: {
                    Text(Localisation.loginTextBtn)
                        .frame(maxWidth: .infinity, minHeight:44)
                        .foregroundColor(.white)
                })
                .background(Color.init("PrimaryColor"))
            }
            
            HStack {
                Text(Localisation.noAccountText)
                NavigationLink(destination: SignupView(), label: { Text(Localisation.signupText) })
            }
            .padding()
            
        }.padding()
        .alert(isPresented: $isRequestErrorViewPresented) {
            Alert(title: Text(Localisation.errorText), message: Text(Localisation.couldnotLoginText), dismissButton: .default(Text(Localisation.okText)))
        }
        .navigationTitle(Localisation.navTextLogin)
    }
    
    
    
}
