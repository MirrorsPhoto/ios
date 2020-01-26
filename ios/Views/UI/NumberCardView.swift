//
//  CardView.swift
//  ios
//
//  Created by Сергей Прищенко on 16.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct NumberCardView: View {
    
    var text: String
    var number: Int
    var formatter = { (_ value: Int) -> String in
        return String(value)
    }
    
    var body: some View {
        CardView() {
            HStack {
                VStack {
                    Text(self.text)
                        .font(.largeTitle)
                }
                Spacer()
                VStack {
                    Text(self.formatter(self.number))
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                }
            }
        }
    }
}

struct NumberCardView_Previews: PreviewProvider {
    static var previews: some View {
            NumberCardView(text: "🥬", number: 99999).frame(width: 266, height: 50)
    }
}
