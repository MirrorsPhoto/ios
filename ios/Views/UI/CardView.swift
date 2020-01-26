//
//  CardView.swift
//  ios
//
//  Created by Сергей Прищенко on 26.01.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import SwiftUI

struct CardView<Content: View>: View {
    
    let content: () -> Content

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.accentColor)
                .cornerRadius(10)
            content()
            .padding(5)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView() {
            Text("VIEW")
        }.frame(width: 266, height: 50)
    }
}
