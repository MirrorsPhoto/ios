//
//  CardView.swift
//  ios
//
//  Created by Сергей Прищенко on 16.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    var text: String
    var number: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.accentColor)
                .cornerRadius(10)
                .padding(5)
            HStack {
                VStack {
                    Text(text)
                        .font(.largeTitle)
                }
                Spacer()
                VStack {
                    Text(String(number))
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                }
            }
            .padding(20)
        }.frame(width: 170, height: 85)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(text: "💰", number: 9999)
    }
}
