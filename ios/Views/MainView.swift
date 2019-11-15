//
//  MainView.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI
import JWTDecode
import SwURL

struct MainView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text(verbatim: sessionManager.user!.username)
                Spacer()
                Button(action: {
                    self.logOut()
                }) {
                    Text("Logout")
                }
            }
            .navigationBarTitle(Text("Dashboard"))
            .navigationBarItems(
                trailing:
                    VStack {
                        RemoteImageView(url: URL(string: sessionManager.user!.avatar)!)
                        .scaledToFit()
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    }
                    .frame(width: 50, height: 50)
                
            )
        }
    }
    
    func logOut() {
        sessionManager.logOut()
        UserDefaults.standard.removeObject(forKey: "token")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sessionManager: SessionManager())
    }
}
