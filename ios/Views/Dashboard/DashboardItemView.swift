//
//  DashboardItemView.swift
//  ios
//
//  Created by Сергей Прищенко on 10.03.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct DashboardItemView: View {
    var iconName: String
    var label: LocalizedStringKey
    var value: Int
    
    var formatter = { (_ value: Int) -> String in
        return String(value)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: self.iconName)
                .foregroundColor(.accentColor)
                .font(.system(size: 48))
            VStack(alignment: .leading) {
                Text(self.label)
                    .font(.subheadline)
                Spacer()
                Text(verbatim: self.formatter(self.value))
                    .font(.system(size: 18))
                    .bold()
            }
            Spacer()
        }.padding()
    }
}

struct DashboardItemView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardItemView(iconName: "rublesign.square", label: "Cash", value: 420)
    }
}
