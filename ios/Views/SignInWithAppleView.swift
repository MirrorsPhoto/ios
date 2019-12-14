//
//  SignInWithAppleView.swift
//  ios
//
//  Created by Сергей Прищенко on 13.12.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .whiteOutline)
        
        button.addTarget(context.coordinator, action:  #selector(Coordinator.didTapButton), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}

class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  let parent: SignInWithAppleView
  
  init(_ parent: SignInWithAppleView) {
    self.parent = parent
    
    super.init()
  }
  
  @objc func didTapButton() {
      let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                      ASAuthorizationPasswordProvider().createRequest()]
      
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
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          
          let userIdentifier = appleIDCredential.user
          let fullName = appleIDCredential.fullName
          let email = appleIDCredential.email
        print(userIdentifier, fullName, email)
        if let authorizationCode = appleIDCredential.authorizationCode,
        let identifyToken = appleIDCredential.identityToken {
            print(String(decoding: authorizationCode, as: UTF8.self))
            print(String(decoding: identifyToken, as: UTF8.self))
        }
      } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
          // Sign in using an existing iCloud Keychain credential.
          let username = passwordCredential.user
          let password = passwordCredential.password
        print(username, password)
      }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
  }
}
