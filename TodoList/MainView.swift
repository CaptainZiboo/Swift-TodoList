//
//  MenuView.swift
//  TodoList
//
//  Created by POYART Lucas on 15/10/2024.
//

import SwiftUI

struct MenuView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isValid: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Nom d'utilisateur", text: $username)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    if isValid {
                        Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
                            // Submit
                        }
                    }
                }
                .padding()
                .formStyle(.columns)
            }
        }
    }
}

#Preview {
    MenuView()
}
