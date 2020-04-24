//
//  DashboardBarItem.swift
//  ios
//
//  Created by Сергей Прищенко on 10.03.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import Foundation
import SwiftUI

class DashboardBarItem: Identifiable {
    let id = UUID()
    let color: Color
    let icon: Image
    let percent: Double
    
    init(_ type: String, percent: Double) {
        var iconName: String
        
        switch type {
        case "photo":
            color = .red
            iconName = "camera"
        case "good":
            color = .orange
            iconName = "cart"
        case "lamination":
            color = .blue
            iconName = "square.stack"
        case "service":
            color = Color(UIColor.systemIndigo)
            iconName = "wrench"
        case "copy":
            color = .green
            iconName = "doc.on.doc"
        case "document":
            color = .pink
            iconName = "doc.plaintext"
        case "printing":
            color = .yellow
            iconName = "printer"
        default:
            color = .orange
            iconName = "xmark.seal"
        }
        
        self.icon = Image(systemName: iconName)
        self.percent = percent
    }
}
