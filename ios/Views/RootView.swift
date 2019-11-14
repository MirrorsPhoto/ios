//
//  RootView.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        Group() {
            if sessionManager.isLogin {
                MainView(sessionManager: sessionManager)
            } else {
                AuthView(sessionManager: sessionManager)
            }
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(sessionManager: SessionManager())
    }
}
#endif
