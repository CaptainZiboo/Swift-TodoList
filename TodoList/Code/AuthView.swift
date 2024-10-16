//
//  LoginView.swift
//  TodoList
//
//  Created by POYART Lucas on 16/10/2024.
//

import SwiftUI

enum AuthMode {
    case login
    case registration
}

struct AuthView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""

    @State var mode: AuthMode = .login
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
       VStack {
                Form {
                    
                    Text(mode == .login ? "Connexion" : "Inscription")
                    
                    TextField("Nom d'utilisateur", text: $username)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(mode == .login ? "Connexion" : "Inscription") {
                        mode == .login
                            ? authViewModel.signIn(username, password)
                            : authViewModel.signUp(username, password)
                    }
                    
                    Button(mode == .login ? "Inscription" : "Connexion") {
                        mode = mode == .login ? .registration : .login
                    }
                }
                .padding()
                .formStyle(.columns)
            }
        
    }
}

#Preview {
    AuthView()
}
