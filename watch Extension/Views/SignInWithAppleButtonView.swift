//
//  SignInWithAppleButtonView.swift
//  watch Extension
//
//  Created by Сергей Прищенко on 12.04.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: WKInterfaceObjectRepresentable {
    
    @ObservedObject var sessionManager: SessionManager
    
    @Binding var showingAlert: Bool
    @Binding var alertText: String
    
    typealias WKInterfaceObjectRepresentable = WKInterfaceObjectRepresentableContext<SignInWithAppleButtonView>

    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceAuthorizationAppleIDButton, context: WKInterfaceObjectRepresentableContext<SignInWithAppleButtonView>) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeWKInterfaceObject(context: WKInterfaceObjectRepresentableContext<SignInWithAppleButtonView>) -> WKInterfaceAuthorizationAppleIDButton {
        return WKInterfaceAuthorizationAppleIDButton(target: context.coordinator, action: #selector(Coordinator.buttonPressed))
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate {

        let parent: SignInWithAppleButtonView

        init(_ parent: SignInWithAppleButtonView) {
          self.parent = parent
          
          super.init()
        }
        
        @objc func buttonPressed() {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            self.parent.sessionManager.signInWithApple(authorization)
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {}

    }
}
