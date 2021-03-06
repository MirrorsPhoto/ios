//
//  GoodsView.swift
//  ios
//
//  Created by Сергей Прищенко on 11.02.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI
import Alamofire

struct GoodsView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    @State var items = [Good]()
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
    
    @State private var showingAlert = false
    @State private var alertText = ""
    
    @State private var isShowModal = false
    @State private var showModal: Sheet = .none
    @State private var currentItem: Good = .default
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.items) { item in
                    Button(action: {
                        self.currentItem = item
                        self.isShowModal.toggle()
                        self.showModal = .detail
                    }) {
                        VStack(alignment: .leading) {
                            Text(verbatim: item.name)
                                .font(.headline)
                            if item.description != nil {
                                Text(verbatim: item.description!)
                            }
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle(Text("Goods"))
            .navigationBarItems(
                trailing: Button(action: {
                    self.isShowModal.toggle()
                    self.showModal = .add
                }) {
                    Image(systemName: "plus")
                    .font(.title)
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: loadData)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(self.alertText), dismissButton: .default(Text("OK")))
        }.sheet(isPresented: $isShowModal) {
            if self.showModal == .add {
                GoodAddView(items: self.$items, show: self.$isShowModal)
            }
            if self.showModal == .detail {
                GoodView(items: self.$items, good: self.$currentItem, show: self.$isShowModal)
            }
        }
    }
    
    func loadData() {
        let token = self.sharedDefaults!.string(forKey: "token")!
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        Alamofire.request("http://api.mirrors-photo.ru/good", headers: headers).responseJSON { (response) in
            let goodResponse = try! JSONDecoder().decode(GoodsResponse.self, from: response.data!)
            
            self.items = goodResponse.response
        }
    }

    func delete(at offsets: IndexSet) {
        let item = items[offsets.max()!]
        
        let token = self.sharedDefaults!.string(forKey: "token")!
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        Alamofire.request("http://api.mirrors-photo.ru/good/\(item.id)/delete", headers: headers).responseJSON { (response) in
            switch response.result {
            case .failure(_):
                self.showingAlert = true
                self.alertText = "Invalid information received from service"
                
                return
            case .success(_):
                print("")
            }

            self.items.remove(atOffsets: offsets)
        }
    }
    
    enum Sheet {
        case none
        case add
        case detail
    }
}

struct GoodsView_Previews: PreviewProvider {
    static var previews: some View {
        GoodsView(sessionManager: SessionManager())
    }
}
