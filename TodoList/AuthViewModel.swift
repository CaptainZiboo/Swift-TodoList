//
//  AuthController.swift
//  TodoList
//
//  Created by POYART Lucas on 15/10/2024.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    private let key: String = "auth"
    
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()
    
    let repository: UserRepository
    
    @Published var user: UserCodable? = nil {
        didSet {
            if let user {
                if let encoded = try? encoder.encode(user) {
                    UserDefaults.standard.setValue(encoded, forKey: key)
                }
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
        
    init(_ repository: UserRepository) {
        self.repository = repository
        
        if let data = UserDefaults.standard.data(forKey: key) {
            if let user = try? decoder.decode(UserCodable.self, from: data) {
                self.user = user
            }
        }
    }
    
    func signUp(_ username: String, _ password: String) {
        let user: User? = self.repository.create(username, password)
        
        if let user {
            self.user = UserCodable(user)
        } else {
            // notify
        }
    }
    
    func signIn(_ username: String, _ password: String) {
        let user: User? =  self.repository.getByName(username)
        
        if let user {
            self.user = UserCodable(user)
        } else {
            // notify
        }
    }
    
    func signOut() {
        self.user = nil
    }
}
