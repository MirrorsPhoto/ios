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
    
    var body: some View {
        NavigationView {
            List(self.items) { item in
                NavigationLink(destination: GoodView(good: item)) {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.description)
                    }
                }
            }
            .navigationBarTitle(Text("Goods"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: loadData)
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
}

struct GoodsView_Previews: PreviewProvider {
    static var previews: some View {
        GoodsView(sessionManager: SessionManager())
    }
}
