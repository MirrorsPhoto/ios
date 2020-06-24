//
//  CashView.swift
//  ios
//
//  Created by Сергей Прищенко on 24.06.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct CashView: View {
    var value: Int
    
    var body: some View {
        DashboardItemView(iconName: "rublesign.square", label: "Cash", value: value, formatter: Helper.formatCurrency)
    }
}

struct CashView_Previews: PreviewProvider {
    static var previews: some View {
        CashView(value: 420)
    }
}