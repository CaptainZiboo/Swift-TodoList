//
//  AuthController.swift
//  TodoList
//
//  Created by POYART Lucas on 15/10/2024.
//

import SwiftUI

enum AuthError: Error, LocalizedError {
    case alreadyExists
    case wrongPassword
    case doesNotExist
    case unknown

    var errorDescription: String? {
        switch self {
            case .alreadyExists:
                return "Ce nom d'utilisateur est déjà utilisé !"
            case .wrongPassword:
                return "Mot de passe incorrect !"
            case .doesNotExist:
                return "Ce compte n'existe pas !"
            default:
                return "Une erreur est survenue !"
        }
    }
}

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
    
    @Published var isError: Bool = false
    
    @Published var error: AuthError? {
        didSet {
            isError = error != nil
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
        guard repository.getByName(username) == nil else {
            error = .alreadyExists
            return
        }
        
        if let user = repository.create(username, password) {
             self.user = UserCodable(user)
        } else {
            error = .unknown
        }
    }
    
    func signIn(_ username: String, _ password: String) {
        if let user = repository.getByName(username) {
            if user.password == password {
                self.user = UserCodable(user)
            } else {
                error = .wrongPassword
            }
        } else {
            error = .doesNotExist
        }
    }
    
    func signOut() {
        self.user = nil
    }
}
