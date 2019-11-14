//
//  MainView.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        VStack {
            Text("MAIN")
            Button(action: logOut) {
                Text("Log out")
            }
        }
    }
    
    func logOut () {
        sessionManager.logOut()
        UserDefaults.standard.removeObject(forKey: "token")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sessionManager: SessionManager())
    }
}
