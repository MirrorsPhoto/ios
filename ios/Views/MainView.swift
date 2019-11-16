//
//  MainView.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI
import JWTDecode
import SwURL

struct MainView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    @State private var showUserDetailModal = false
    
    var body: some View {
        NavigationView {
             ScrollView {
                VStack {
                    HStack {
                        CardView(text: "💰", number: sessionManager.totalCash ?? 0)
                        CardView(text: "🧟‍♀️",  number: sessionManager.totalClient ?? 0)
                    }
                    Spacer()
                }
             }
             .navigationBarTitle(Text("Dashboard"))
            .navigationBarItems(
                trailing:
                    Button(action: {
                        self.showUserDetailModal.toggle()
                    }) {
                        VStack {
                            RemoteImageView(url: URL(string: sessionManager.user!.avatar!)!, imageRenderingMode: .original)
                            .scaledToFit()
                            .clipShape(Circle())
                            .shadow(radius: 10)
                        }
                        .frame(width: 50, height: 50)
                    }
            )
            .sheet(isPresented: self.$showUserDetailModal) {
                UserDetailView(sessionManager: self.sessionManager, showUserDetailModal: self.$showUserDetailModal)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sessionManager: SessionManager())
    }
}
