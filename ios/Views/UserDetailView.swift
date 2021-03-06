//
//  UserDetailView.swift
//  ios
//
//  Created by Сергей Прищенко on 15.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI
import SwURL

struct UserDetailView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        RemoteImageView(url: URL(string: sessionManager.user!.avatar!)!, imageRenderingMode: .original)
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(height: 100)
                        Spacer()
                        VStack {
                            Text(verbatim: sessionManager.user!.firstName)
                                .font(.title)
                            Text(verbatim: sessionManager.user!.lastName)
                                .font(.title)
                            Text(verbatim: sessionManager.user!.email)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    Spacer()
                    if sessionManager.user!.sub == nil {
                        ContinueWithAppleButton(sessionManager: sessionManager)
                            .frame(width: 200, height: 50)
                    }
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
                .padding()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func logOut() {
        PushNotification.unregisterDeviceToken()
        sessionManager.logOut()
    }
}
