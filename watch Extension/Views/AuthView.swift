//
//  AuthView.swift
//  watch Extension
//
//  Created by Сергей Прищенко on 12.12.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI
import Alamofire

struct AuthView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    @State var login = ""
    @State var password = ""
    
    @State var showingAlert = false
    @State var alertText = ""
    
    var body: some View {
        ScrollView {
            TextField("Login", text: $login)
                .textContentType(.username)
            SecureField("Password", text: $password)
                .textContentType(.password)
            Button(action: {
                self.signIn()
            }) {
                Text("Sign in")
                    .font(.headline)
                    
            }
            .disabled(login.isEmpty || password.isEmpty)
            SignInWithAppleButton(sessionManager: sessionManager, showingAlert: $showingAlert, alertText: $alertText)
        }
        .navigationBarTitle(Text("Authorization"))
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(self.alertText), dismissButton: .default(Text("OK")))
        }
    }
    
    func signIn() {
        let parameters: Parameters = [
            "login": self.login,
            "password": self.password
        ]
        
        Alamofire.request("http://api.mirrors-photo.ru/login", method: .post, parameters: parameters).responseJSON { (response) in
            guard let responseJSON = response.result.value as? [String: Any] else {
                self.showingAlert = true
                self.alertText = "Invalid information received from service"
                return
            }
            
            guard responseJSON["status"] as! String == "OK" else {
                self.showingAlert = true
                self.alertText = "Invalid login or password"
                return
            }
            
            guard let result = responseJSON["response"] as? [String: String] else {
                self.showingAlert = true
                self.alertText = "Invalid response format"
                return
            }
            
            guard let token = result["token"] else {
                self.alertText = "Invalid token format"
                return
            }
            
            let sharedDefaults = UserDefaults(suiteName: "group.com.mirrors.ios.widget.data")
            
            sharedDefaults!.set(token, forKey: "token")
            self.sessionManager.signIn(token: token)
            PushNotification.register()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(sessionManager: SessionManager())
    }
}
