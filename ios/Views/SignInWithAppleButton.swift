//
//  SignInWithAppleView.swift
//  ios
//
//  Created by Сергей Прищенко on 13.12.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import Alamofire

struct SignInWithAppleButton: UIViewRepresentable {
    
    @ObservedObject var sessionManager: SessionManager
    
    @Binding var showingAlert: Bool
    @Binding var alertText: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        
        button.cornerRadius = 10
        
        button.addTarget(context.coordinator, action: #selector(Coordinator.didTapButton), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}

class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    let parent: SignInWithAppleButton
  
    init(_ parent: SignInWithAppleButton) {
        self.parent = parent
    
        super.init()
    }
  
    @objc func didTapButton() {
        let requests = [
            ASAuthorizationAppleIDProvider().createRequest(),
        ]
      
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
    
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
  
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        
        return (vc?.view.window!)!
    }
  
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        self.parent.sessionManager.signInWithApple(authorization)
    }
  
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {}
    
}
