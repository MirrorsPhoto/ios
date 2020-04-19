//
//  GoodsView.swift
//  watch Extension
//
//  Created by Сергей Прищенко on 13.04.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI
import Alamofire

struct GoodsView: View {
    
    @State var items = [Good]()
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.mirrors.ios.widget.data")
    
    var body: some View {
        List {
            ForEach(self.items) { item in
                NavigationLink(destination: GoodView(good: item)) {
                    VStack(alignment: .leading) {
                        Text(verbatim: item.name)
                            .font(.headline)
                        if item.description != nil {
                            Text(verbatim: item.description!)
                        }
                    }
                }.padding()
            }
        }
        .navigationBarTitle(Text("Goods"))
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
        GoodsView()
    }
}
