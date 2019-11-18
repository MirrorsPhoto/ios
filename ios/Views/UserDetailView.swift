//
//  UserDetailView.swift
//  ios
//
//  Created by Сергей Прищенко on 15.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    @Binding var showUserDetailModal: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello")
            }
            .navigationBarTitle(Text(verbatim: sessionManager.user!.username))
            .navigationBarItems(
                trailing:
                    Button(action: {
                        self.logOut()
                    }) {
                        Text("Logout").foregroundColor(Color.red)
                }
            )
        }
    }
    
    func logOut() {
        self.showUserDetailModal.toggle()
        sessionManager.logOut()
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.mirrors.ios.widget.data")
        
        sharedDefaults!.removeObject(forKey: "token")
    }
}
