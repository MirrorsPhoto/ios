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
    
    @State private var isShowModal = false
    @State private var showModal: Sheet = .none
    
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
    
    @State private var isEditMode = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    if (isEditMode) {
                        TextField("", text: $good.name)
                    } else {
                        Text(verbatim: good.name)
                    }
                }
                Section(header: Text("Description")) {
                    if (isEditMode) {
                        TextField("", text: description)
                    } else {
                        Text(verbatim: good.description ?? "")
                    }
                }
                Section(header: Text("Barcode")) {
                    if (isEditMode) {
                        ZStack(alignment: .trailing) {
                            TextField("", text: barCode)
                                .keyboardType(.numberPad)
                            Image(systemName: "barcode.viewfinder")
                                .foregroundColor(.accentColor)
                                .font(.title)
                                .padding(.trailing, 16)
                                .onTapGesture {
                                    self.isShowModal = true
                                    self.showModal = .cameraCode
                                }
                        }
                    } else {
                        HStack(alignment: .center) {
                            Text(verbatim: good.bar_code ?? "")
                            Spacer()
                            if self.generateBarCode() != nil {
                                Image(systemName: "eye")
                                    .foregroundColor(.accentColor)
                                    .font(.title)
                                    .padding(.trailing, 16)
                                    .onTapGesture {
                                        self.isShowModal = true
                                        self.showModal = .showCode
                                    }
                            }
                        }
                    }
                }
                Section(header: Text("Price")) {
                    if (isEditMode) {
                        TextField("", value: $good.price, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    } else {
                        Text(verbatim: Helper.formatCurrency(good.price))
                    }
                }
                Section(header: Text("Available")) {
                    Text(verbatim: String(good.available))
                }
            }
            .navigationBarTitle(isEditMode ? Text("Edit good") : Text("Detail good"))
            .navigationBarItems(
                leading:
                    isEditMode ?
                    AnyView(Button(action: {
                        self.isEditMode = false
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            
                    }) :
                    AnyView(EmptyView()),
                trailing:
                    isEditMode ?
                    AnyView(Button(action: {
                        self.edit()
                    }) {
                        Text("Done")
                            .font(.headline)
                    }.disabled(pendingRequest || self.good.name.isEmpty || self.good.price <= 0)) :
                    AnyView(Button(action: {
                        self.isEditMode = true
                    }) {
                        Text("Edit")
                            .font(.headline)
                    })
                
            )
        }
        .sheet(isPresented: $isShowModal) {
            if self.showModal == .cameraCode {
                CarBode(supportBarcode: [.ean13])
                .interval(delay: 0.5)
                .found {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self.good.bar_code = $0
                    self.isShowModal = false
                }
            }
            if self.showModal == .showCode {
                if self.generateBarCode() != nil {
                    ZStack {
                        Color.white.edgesIgnoringSafeArea(.all)
                        self.generateBarCode()
                            .frame(height: 120)
                            .foregroundColor(.black)
                    }
                } else {
                    Text("Barcode: \(self.good.bar_code ?? "")")
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(self.alertText), dismissButton: .default(Text("OK")))
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
    
    enum Sheet {
        case none
        case cameraCode
        case showCode
    }
}
