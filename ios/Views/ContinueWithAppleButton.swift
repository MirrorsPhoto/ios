//
//  ContinueWithAppleButton.swift
//  ios
//
//  Created by Сергей Прищенко on 15.12.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import Alamofire

struct ContinueWithAppleButton: UIViewRepresentable {
    
    @ObservedObject var sessionManager: SessionManager
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
    
    func makeCoordinator() -> CoordinatorContinue {
        return CoordinatorContinue(self)
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .white)
        
        button.cornerRadius = 10
        
        button.addTarget(context.coordinator, action: #selector(CoordinatorContinue.didTapButton), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}

class CoordinatorContinue: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    let parent: ContinueWithAppleButton
  
    init(_ parent: ContinueWithAppleButton) {
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
            let identifyToken = String(decoding: credentials.identityToken!, as: UTF8.self)
        
            let parameters: Parameters = [
                "token": identifyToken,
            ]

            let token = self.parent.sharedDefaults?.string(forKey: "token")!
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token!)"
            ]

            Alamofire.request("http://api.mirrors-photo.ru/apple/subscribe", method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
                guard let responseJSON = response.result.value as? [String: Any] else {
                    return
                }
                
                guard responseJSON["status"] as! String == "OK" else {
                    return
                }
                
                guard let result = responseJSON["response"] as? [String: String] else {
                    return
                }
                
                guard let token = result["token"] else {
                    return
                }
                
                let sharedDefaults = UserDefaults(suiteName: "group.com.mirrors.ios.widget.data")
                
                sharedDefaults!.set(token, forKey: "token")
                self.parent.sessionManager.signIn(token: token)
            }
    }
  
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {}
    
}
