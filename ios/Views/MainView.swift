//
//  MainView.swift
//  ios
//
//  Created by Сергей Прищенко on 14.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI
import SwURL

struct MainView: View {
    
    @ObservedObject var sessionManager: SessionManager
    
    @State private var showUserDetailModal = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        NumberCardView(text: "🧟‍♀️",  number: self.sessionManager.todaySummary.client.today, formatter: Helper.formatNumber)
                        NumberCardView(text: "🥬", number: self.sessionManager.todaySummary.cash.today.total, formatter: Helper.formatCurrency)
                    }
                }
                Spacer()
            }
            .padding([.horizontal])
            .navigationBarTitle(Text("Dashboard"))
            .navigationBarItems(
                trailing: Button(action: {
                    self.showUserDetailModal.toggle()
                }) {
                        HStack {
                            Spacer()
                            RemoteImageView(url: URL(string: sessionManager.user!.avatar!)!, imageRenderingMode: .original)
                                .scaledToFit()
                                .clipShape(Circle())
                            Spacer()
                        }
                        .frame(width: 50, height: 50)
                }
            )
                .sheet(isPresented: self.$showUserDetailModal) {
                    UserDetailView(sessionManager: self.sessionManager, showUserDetailModal: self.$showUserDetailModal)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sessionManager: SessionManager())
    }
}
