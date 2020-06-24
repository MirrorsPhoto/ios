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
    
    var bars: [DashboardBarItem] {
        let today = self.sessionManager.todaySummary.cash.today
        let childrens = Mirror(reflecting: today).children
        var data = [DashboardBarItem]()
        let sum = Double(today.sum())
        
        for (_, attr) in childrens.enumerated() {
            let value = attr.value as? Int
            
            let name = attr.label!
            if name == "total" {
                continue
            }
            
            let percent: Double = sum != 0 ? Double(value!) * 100.0 / sum : 0.0
            
            data.append(DashboardBarItem(name, percent: percent))
        }
        
        data = data.sorted(by: { $0.percent > $1.percent })
        
        return data
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    CashView(value: self.sessionManager.todaySummary.cash.today.total)
                    ClientView(value: self.sessionManager.todaySummary.client.today)
                }
                VStack(alignment: .leading) {
                    ForEach(self.bars) { bar in
                        DashboardBarItemView(bar: bar).padding([.top, .bottom], 4)
                    }
                }.padding()
            }
            .navigationBarTitle(Text("Dashboard"))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(sessionManager: SessionManager())
    }
}
