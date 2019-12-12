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
            Row(text: "🧟‍♀️",  number: self.sessionManager.totalClient ?? 0, formatter: Helper.formatNumber)
            Row(text: "🥬", number: self.sessionManager.totalCash ?? 0, formatter: Helper.formatCurrency)
        }
        .listStyle(CarouselListStyle())
        .navigationBarTitle(Text("Dashboard"))
    }
}

struct Row: View {
    
    var text: String
    var number: Int
    var formatter = { (_ value: Int) -> String in
        return String(value)
    }
    
    var body: some View {
        HStack {
            Text(verbatim: self.text)
                .font(.largeTitle)
            Spacer()
            Text(verbatim: formatter(self.number))
                .font(.largeTitle)
        }
            .listRowPlatterColor(Color.blue)
            .frame(height: 60)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sessionManager: SessionManager())
    }
}
