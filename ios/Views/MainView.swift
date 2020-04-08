//
//  MainView.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI
import SwURL

struct MainView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        TabView() {
            DashboardView(sessionManager: sessionManager)
                .tabItem {
                    Image(systemName: "house")
                        .font(.headline)
                    Text("Dashboard")
                }
            GoodsView(sessionManager: sessionManager)
                .tabItem {
                    Image(systemName: "bag")
                        .font(.headline)
                    Text("Goods")
                }
            UserDetailView(sessionManager: sessionManager)
                .tabItem {
                    Image(systemName: "person")
                        .font(.headline)
                    Text(verbatim: sessionManager.user!.username)
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sessionManager: SessionManager())
    }
}
