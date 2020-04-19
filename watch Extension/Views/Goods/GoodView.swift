//
//  GoodView.swift
//  watch Extension
//
//  Created by Сергей Прищенко on 13.04.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI
import BarcodeView

struct GoodView: View {
    
    @State var good: Good
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                Text(verbatim: good.name)
            }
            Section(header: Text("Description")) {
                Text(verbatim: good.description ?? "")
            }
            if self.good.bar_code != nil {
                Section(header: Text("Barcode")) {
                    if self.generateBarCode() != nil {
                        NavigationLink(destination: GoodBarcodeView(barCode: self.generateBarCode()!)) {
                            HStack(alignment: .center) {
                                Text(verbatim: good.bar_code!)
                            }
                        }
                    } else {
                        HStack(alignment: .center) {
                            Text(verbatim: good.bar_code!)
                        }
                    }
                }
            }
            Section(header: Text("Price")) {
                Text(verbatim: Helper.formatCurrency(good.price))
            }
            Section(header: Text("Available")) {
                Text(verbatim: String(good.available))
            }
        }
        .navigationBarTitle(Text("Good"))
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
