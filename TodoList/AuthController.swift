//
//  AuthController.swift
//  TodoList
//
//  Created by POYART Lucas on 15/10/2024.
//

import SwiftUI

class AuthController {
    @State static var user: User? // = UserDefaults.standard.value(forKey: self.key)
    
    private static let key: String = "auth"
    
    static func signUp(_ name: String, _ password: String) {
        
        
        UserDefaults.standard.setValue(nil, forKey: self.key)
    }
    
    static func signIn(_ name: String, _ password: String) {
        
    }
    
    static func signOut() {
        self.user = nil
        UserDefaults.standard.removeObject(forKey: self.key)
    }
}
