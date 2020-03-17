//
//  GoodView.swift
//  ios
//
//  Created by Сергей Прищенко on 11.02.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI
import CarBode
import BarcodeView
import Alamofire

struct GoodView: View {
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
    
    @Binding var items: [Good]
    
    @Binding var good: Good
    
    @Binding var show: Bool
    
    @State private var showBarCodeCameraModal = false
    @State private var pendingRequest = false
    
    @State private var showingAlert = false
    @State private var alertText = ""
    
    var description: Binding<String> {
        Binding<String>(
            get: { self.good.description ?? ""},
            set: { self.good.description = $0 })
    }
    
    var barCode: Binding<String> {
        Binding<String>(
            get: { self.good.bar_code ?? ""},
            set: { self.good.bar_code = $0 })
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("", text: $good.name)
                }
                Section(header: Text("Description")) {
                    TextField("", text: description)
                }
                Section(header: Text("Barcode")) {
                    ZStack(alignment: .trailing) {
                        TextField("", text: barCode)
                            .keyboardType(.numberPad)
                        Image(systemName: "barcode.viewfinder")
                            .foregroundColor(.accentColor)
                            .font(.title)
                            .padding(.trailing, 16)
                            .onTapGesture {
                                self.showBarCodeCameraModal = true
                            }
                    }
                }
                Section(header: Text("Price")) {
                    TextField("", value: $good.price, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle(Text("Edit good"))
            .navigationBarItems(
                leading: Button(action: {
                    self.show.toggle()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        
                },
                trailing: Button(action: {
                    self.edit()
                }) {
                    Text("Done")
                        .font(.headline)
                }.disabled(pendingRequest || self.good.name.isEmpty || self.good.price <= 0)
            )
        }
        .sheet(isPresented: $showBarCodeCameraModal) {
            CarBode(supportBarcode: [.ean13])
                .interval(delay: 0.5)
                .found {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self.good.bar_code = $0
                    self.showBarCodeCameraModal = false
                }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(self.alertText), dismissButton: .default(Text("OK")))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func edit() {
        self.pendingRequest = true
        let name = self.good.name
        let description = self.description.wrappedValue
        let barCode = self.barCode.wrappedValue
        let price = Int(self.good.price)
        let id = self.good.id
        
        let parameters: Parameters = [
            "name": name,
            "description": description,
            "bar_code": barCode,
            "price": price
        ]

        let token = self.sharedDefaults?.string(forKey: "token")!
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token!)"
        ]
        
        Alamofire.request("http://api.mirrors-photo.ru/good/\(id)", method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
            case .failure(_):
                self.pendingRequest = false
                self.showingAlert = true
                self.alertText = "Invalid information received from service"
                
                return
            case .success(_):
                print("")
            }
            
            let goodResponse = try! JSONDecoder().decode(GoodsResponse.self, from: response.data!)
            
            for good in goodResponse.response {
                let index = self.items.firstIndex(where: {$0.id == id})!
                self.items[index] = good
            }
            
            self.show.toggle()
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
