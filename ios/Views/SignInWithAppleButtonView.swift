//
//  SignInWithAppleButtonView.swift
//  ios
//
//  Created by Сергей Прищенко on 26.06.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct SignInWithAppleButtonView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { (request) in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { (result) in
                switch result {
                case .success(let authorization):
                    self.sessionManager.signInWithApple(authorization)
                case .failure(_):
                    return;
                }
            })
    }
}

struct SignInWithAppleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleButtonView(sessionManager: SessionManager())
    }
}
