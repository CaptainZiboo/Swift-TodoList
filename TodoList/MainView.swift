//
//  MenuView.swift
//  TodoList
//
//  Created by POYART Lucas on 15/10/2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var authViewModel = AuthViewModel(UserRepository(DataController()))
    
    var body: some View {
        VStack {
            if authViewModel.user != nil {
                ContentView()
                
                Button("Logout") {
                    authViewModel.signOut()
                }
            } else {
                AuthView()
            }
        }
        .environmentObject(authViewModel)
        
    }
}

#Preview {
    MainView()
}
