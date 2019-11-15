//
//  SessionStore.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//
import Combine
import JWTDecode

class SessionManager : ObservableObject {
    
    @Published var isLogin = false
    @Published var user: User?
    
    init(token: String? = nil) {
        if token == nil {
            return
        }
        
        setToken(token: token!)
    }
    
    func signIn(token: String) {
        setToken(token: token)
    }
    
    func logOut() {
        self.isLogin = false
    }
    
    private func setToken(token: String) {
        let jwt = try? decode(jwt: token)
        
        self.user = User(data: jwt?.body)
        self.isLogin = true
    }
}
