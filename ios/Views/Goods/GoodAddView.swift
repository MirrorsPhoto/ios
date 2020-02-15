//
//  GoodAddView.swift
//  ios
//
//  Created by Сергей Прищенко on 14.02.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI
import CarBode
import Alamofire

struct GoodAddView: View {
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
    
    @Environment(\.presentationMode) var presentation
    
    @Binding var items: [Good]
    
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var barCode = ""
    
    @State private var showModal = false
    @State private var pendingRequest = false
    
    @State private var showingAlert = false
    @State private var alertText = ""
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("", text: $name)
            }
            Section(header: Text("Description")) {
                TextField("", text: $description)
            }
            Section(header: Text("Barcode")) {
                ZStack(alignment: .trailing) {
                    TextField("", text: $barCode)
                        .keyboardType(.numberPad)
                    Image(systemName: "camera")
                        .foregroundColor(.accentColor)
                        .font(.title)
                        .padding(.trailing, 16)
                        .onTapGesture {
                            self.showModal = true
                        }
                }
            }
            Section(header: Text("Price")) {
                TextField("", text: $price)
                    .keyboardType(.numberPad)
            }
            Button(action: {
                self.add()
            }) {
                Text("Add")
                    .font(.headline)
                    
            }
                .disabled(pendingRequest || name.isEmpty || price.isEmpty)
        }
        .sheet(isPresented: $showModal) {
            CarBode(supportBarcode: [.ean13])
                .interval(delay: 0.5)
                .found {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self.barCode = $0
                    self.showModal = false
                }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(self.alertText), dismissButton: .default(Text("OK")))
        }
    }
    
    func add() {
        self.pendingRequest = true
        let name = self.name
        let description = self.description
        let barCode = self.barCode
        let price = Int(self.price)!
        
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
        
        Alamofire.request("http://api.mirrors-photo.ru/good/add", method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
            case let .failure(error):
                self.pendingRequest = false
                self.showingAlert = true
                self.alertText = "Invalid information received from service"
                
                return
            case .success(_):
                print("")
            }
            
            let goodResponse = try! JSONDecoder().decode(GoodsResponse.self, from: response.data!)

            for good in goodResponse.response {
                self.items.append(good)
            }
            
            self.presentation.wrappedValue.dismiss()
        }
    }
}
