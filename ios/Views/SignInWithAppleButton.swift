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
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
            let identifyToken = credentials.identityToken!
        
            let parameters: Parameters = [
                "token": String(decoding: identifyToken, as: UTF8.self),
            ]
            
            Alamofire.request("http://api.mirrors-photo.ru/apple/login", method: .post, parameters: parameters).responseJSON { (response) in
                guard let responseJSON = response.result.value as? [String: Any] else {
                    self.parent.showingAlert = true
                    self.parent.alertText = "Invalid information received from service"
                    return
                }
                
                guard responseJSON["status"] as! String == "OK" else {
                    self.parent.showingAlert = true
                    self.parent.alertText = "Invalid login or password"
                    return
                }
                
                guard let result = responseJSON["response"] as? [String: String] else {
                    self.parent.showingAlert = true
                    self.parent.alertText = "Invalid response format"
                    return
                }
                
                guard let token = result["token"] else {
                    self.parent.alertText = "Invalid token format"
                    return
                }
                
                let sharedDefaults = UserDefaults(suiteName: "group.com.mirrors.ios.widget.data")
                
                sharedDefaults!.set(token, forKey: "token")
                self.parent.sessionManager.signIn(token: token)
            }
    }
  
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {}
    
}
