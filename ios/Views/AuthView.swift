//
//  AuthView.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct AuthView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        VStack {
            Text("AUTH")
            Button(action: logIn) {
                Text("Log in")
            }
        }
    }
    
    func logIn () {
        UserDefaults.standard.set(sessionManager.signIn(), forKey: "token")
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(sessionManager: SessionManager())
    }
}
