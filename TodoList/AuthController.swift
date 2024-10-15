//
//  AuthController.swift
//  TodoList
//
//  Created by POYART Lucas on 15/10/2024.
//

import SwiftUI

class AuthController {
    static let key: String = "auth"
    
    @State static var user: User? {
        didSet {
            if user != nil {
                UserDefaults.standard.value(forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
    // Decode UserDefaults to set user = UserDefaults.standard.value(forKey: key)
    
    static func signUp(_ name: String, _ password: String) {
        let user: User? = DataController.shared.createUser(name, password)
        
        if user != nil {
            self.user = user
        } else {
            // notify
        }
    }
    
    static func signIn(_ name: String, _ password: String) {
        let user: User? = nil // TODO
        
        if user != nil {
            self.user = user
        } else {
            // notify
        }
    }
    
    static func signOut() {
        self.user = nil
    }
    
    // TODO : Dedoce user to init user in state
}
