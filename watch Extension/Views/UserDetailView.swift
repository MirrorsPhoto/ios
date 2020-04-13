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
        }
        .navigationBarTitle(Text(verbatim: sessionManager.user!.username))
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(sessionManager: SessionManager())
    }
}
