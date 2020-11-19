//
//  SignupView.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 13/10/2020.
//

import SwiftUI
import os

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isTryingToSignup: Bool = false
    @State var isRequestErrorViewPresented: Bool = false
    @State var isRegistrationViewPresented: Bool = false
    @State var message: LocalizedStringKey = ""
    
    var disaabledButton: Bool {
        username.count < 4 || password.count < 4 || confirmPassword.count < 4
    }
    
    var body: some View {
        VStack {
            if isTryingToSignup {
                ProgressView(Localisation.tryingToSignup)
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
                SecureField(Localisation.enterConfirmPassword, text: $confirmPassword)
                    .padding()
                    .border(Color.black.opacity(0.2), width: 1)
                    .cornerRadius(3.0)
                Button(action: {
                    if password != confirmPassword {
                        message = Localisation.passwordDoesnotMatch
                        isRequestErrorViewPresented = true
                    } else {
                        isTryingToSignup = true
                        UserViewModel.userVM.register(user: User(username: username, password: password)) { result in
                            switch result {
                                case .success(let response):
                                    if response.success {
                                        self.message = Localisation.successfullyRegistered
                                        self.isRegistrationViewPresented = true
                                    }else {
                                        self.message = Localisation.usernameAlreadyExists
                                        self.isRequestErrorViewPresented = true
                                    }
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
                            self.isTryingToSignup = false
                        }
                    }
                    
                }, label: {
                    Text(Localisation.signupBtn)
                        .frame(maxWidth: .infinity, minHeight:44)
                        .foregroundColor(.white)
                })
                .background(Color.init("PrimaryColor"))
                .disabled(disaabledButton)
            }
            
        }.padding()
        .alert(isPresented: $isRequestErrorViewPresented) {
            Alert(title: Text(Localisation.errorText), message: Text(message), dismissButton: .default(Text(Localisation.okText)))
        }
        .alert(isPresented: $isRegistrationViewPresented) {
            Alert(title: Text(Localisation.registerationText), message: Text(message), dismissButton: .default(Text(Localisation.loginTextBtn), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
        .navigationTitle(Localisation.navTextSignup)
    }
}

