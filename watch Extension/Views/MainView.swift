//
//  MainView.swift
//  watch Extension
//
//  Created by Сергей Прищенко on 12.12.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    @State private var currentTab: Tab = .dashboard
    
    enum Tab: CaseIterable, Identifiable {
        case dashboard
        case goods
        case userDetail
        
        var id: Tab { self }
        func name(_ sessionManager: SessionManager) -> String {
            switch self {
            case .dashboard:
                return String(NSLocalizedString("Dashboard", comment: ""))
            case .goods:
                return String(NSLocalizedString("Goods", comment: ""))
            case .userDetail:
                return sessionManager.user!.username
            }
        }
        var icon: String {
            switch self {
            case .dashboard:
                return "house"
            case .goods:
                return "bag"
            case .userDetail:
                return "person"
            }
        }
    }
    
    var body: some View {
        tabView()
        .contextMenu {
            ForEach(Tab.allCases) { tab in
                if self.currentTab != tab {
                    Button(action: {
                        self.currentTab = tab
                    }, label: {
                        VStack{
                            Image(systemName: tab.icon)
                                .font(.title)
                            Text(verbatim: tab.name(self.sessionManager))
                        }
                    })
                }
            }
        }
    }
    
    func tabView() -> AnyView {
        switch currentTab {
        case .dashboard:
            return AnyView(DashboardView(sessionManager: self.sessionManager))
        case .userDetail:
            return AnyView(UserDetailView(sessionManager: self.sessionManager))
        case .goods:
            return AnyView(GoodsView())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sessionManager: SessionManager())
    }
}
