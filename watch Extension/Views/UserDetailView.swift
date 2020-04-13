//
//  UserDetailView.swift
//  watch Extension
//
//  Created by Сергей Прищенко on 13.04.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        ScrollView {
            Text(verbatim: sessionManager.user!.firstName)
                .font(.title)
            Text(verbatim: sessionManager.user!.lastName)
                .font(.title)
            Text(verbatim: sessionManager.user!.email)
                .font(.caption)
                .foregroundColor(.secondary)
            Divider()
            Button(action: {
                self.logOut()
            }) {
                Text("Logout").foregroundColor(Color.red)
            }
        }
        .navigationBarTitle(Text(verbatim: sessionManager.user!.username))
    }
    
    func logOut() {
        PushNotification.unregisterDeviceToken()
        self.sessionManager.logOut()
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(sessionManager: SessionManager())
    }
}
