//
//  GoodView.swift
//  ios
//
//  Created by Сергей Прищенко on 11.02.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct GoodView: View {
    
    var good: Good
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(good.name)")
            Text("Description: \(good.description)")
            Text("Price: \(good.price)")
            Text("Available: \(good.available)")
            Text("Barcode: \(good.bar_code ?? "")")
        }
    }
}

struct GoodView_Previews: PreviewProvider {
    static var previews: some View {
        GoodView(good: Good(id: 1, name: "Test", description: "Description", bar_code: "12312312", price: 123, available: 1))
    }
}
