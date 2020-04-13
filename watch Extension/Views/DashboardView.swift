//
//  DashboardView.swift
//  watch Extension
//
//  Created by Сергей Прищенко on 13.04.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        List {
            DashboardItemView(iconName: "rublesign.square", label: "Cash", value: self.sessionManager.todaySummary.cash.today.total, formatter: Helper.formatCurrency)
            DashboardItemView(iconName: "person.crop.square", label: "Client", value: self.sessionManager.todaySummary.client.today, formatter: Helper.localizedClientCount)
        }
        .listStyle(CarouselListStyle())
        .navigationBarTitle(Text("Dashboard"))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(sessionManager: SessionManager())
    }
}
