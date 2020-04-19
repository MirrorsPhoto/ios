//
//  GoodBarcodeVIew.swift
//  watch Extension
//
//  Created by Сергей Прищенко on 19.04.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI
import BarcodeView

struct GoodBarcodeView: View {
    
    @State var barCode: BarcodeView
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            self.barCode
                .frame(height: 100)
                .environment(\.barWidth, 1)
                .foregroundColor(.black)
        }
        .navigationBarTitle(Text("Barcode"))
    }
}

struct GoodBarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        GoodBarcodeView(barCode: BarcodeView(BarcodeFactory.barcode(from: "302993918288")!))
    }
}
