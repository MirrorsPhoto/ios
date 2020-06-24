//
//  ClientView.swift
//  ios
//
//  Created by Сергей Прищенко on 24.06.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct ClientView: View {
    var value: Int
    
    var body: some View {
        DashboardItemView(iconName: "person.crop.square", label: "Client", value: value, formatter: Helper.localizedClientCount)
    }
}

struct ClientView_Previews: PreviewProvider {
    static var previews: some View {
        ClientView(value: 36)
    }
}
