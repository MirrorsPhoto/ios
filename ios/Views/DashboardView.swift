//
//  DashboardView.swift
//  ios
//
//  Created by Сергей Прищенко on 10.02.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        NumberCardView(text: "🧟‍♀️",  number: self.sessionManager.todaySummary.client.today, formatter: Helper.formatNumber)
                        NumberCardView(text: "🥬", number: self.sessionManager.todaySummary.cash.today.total, formatter: Helper.formatCurrency)
                    }
                    CardView {
                        PieChartView(data: self.sessionManager.todaySummary.cash.today)
                            .frame(height: 200)
                    }
                }
                Spacer()
            }
            .padding([.horizontal])
            .navigationBarTitle(Text("Dashboard"))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(sessionManager: SessionManager())
    }
}
