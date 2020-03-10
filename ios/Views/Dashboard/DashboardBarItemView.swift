//
//  DashboardBarItemView.swift
//  ios
//
//  Created by Сергей Прищенко on 10.03.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct DashboardBarItemView: View {
    let bar: DashboardBarItem
    
    var body: some View {
        HStack(alignment: .center) {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(self.bar.color)
                    .frame(width: geometry.size.width * CGFloat(self.bar.percent) / 100.0, height: 16)
            }
            Spacer()
            self.bar.icon
                .foregroundColor(self.bar.color)
                .font(.subheadline)
        }
    }
}

struct DashboardBarItemView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardBarItemView(bar: DashboardBarItem("photo", percent: 76))
    }
}
