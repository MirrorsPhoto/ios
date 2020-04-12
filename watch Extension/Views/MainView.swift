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
    
    var body: some View {
        List {
            DashboardItemView(iconName: "rublesign.square", label: "Cash", value: self.sessionManager.todaySummary.cash.today.total, formatter: Helper.formatCurrency)
            DashboardItemView(iconName: "person.crop.square", label: "Client", value: self.sessionManager.todaySummary.client.today, formatter: Helper.localizedClientCount)
        }
        .contextMenu(menuItems: {
            Button(action: {
                PushNotification.unregisterDeviceToken()
                self.sessionManager.logOut()
            }, label: {
                VStack{
                    Image(systemName: "clear")
                        .font(.title)
                    Text("Logout")
                }
            })
        })
        .listStyle(CarouselListStyle())
        .navigationBarTitle(Text("Dashboard"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sessionManager: SessionManager())
    }
}
