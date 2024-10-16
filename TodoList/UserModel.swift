//
//  UserModel.swift
//  TodoList
//
//  Created by POYART Lucas on 16/10/2024.
//

import Foundation

// User related Codable / Decodable entities

struct UserCodable: Codable {
    var id: UUID
    var username: String
    var password: String
    
    // Init Codable from Core Data User entity
    
    init(_ user: User) {
        self.id = user.id ?? UUID()
        self.username = user.username ?? ""
        self.password = user.password ?? ""
    }
}
