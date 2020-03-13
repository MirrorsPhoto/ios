//
//  GoodView.swift
//  ios
//
//  Created by Сергей Прищенко on 11.02.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI
import BarcodeView

struct GoodView: View {
    
    var good: Good
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(good.name)")
            Text("Description: \(good.description ?? "")")
            Text("Price: \(good.price)")
            Text("Available: \(good.available)")
            if self.generateBarCode() != nil {
                self.generateBarCode().frame(height: 120)
            } else {
                Text("Barcode: \(good.bar_code ?? "")")
            }
        }
    }
    
    func generateBarCode() -> BarcodeView? {
        guard let barcodeStr = self.good.bar_code else {
            return nil
        }
        
        guard let barcode = BarcodeFactory.barcode(from: barcodeStr) else {
            return nil
        }
        
        return BarcodeView(barcode)
    }
}

struct GoodView_Previews: PreviewProvider {
    static var previews: some View {
        GoodView(good: Good(id: 1, name: "Test", description: "Description", bar_code: "12312312", price: 123, available: 1))
    }
}
