//
//  SessionStore.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//
import Combine

class SessionManager : ObservableObject {
    
    @Published var isLogin: Bool
    
    init(isLogin: Bool = true) {
        self.isLogin = isLogin
    }
    
    func signIn() -> String {
        self.isLogin = true
        
        return "123213"
    }
    
    func logOut() {
        self.isLogin = false
    }
}
