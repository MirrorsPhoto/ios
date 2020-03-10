//
//  Helpers.swift
//  ios
//
//  Created by Сергей Прищенко on 22.11.2019.
//  Copyright © 2019 Mirror's Photo. All rights reserved.
//

import Foundation

class Helper {
    
    static func formatCurrency(_ amount: Int) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "₽"
        currencyFormatter.maximumFractionDigits = 0
        
        return currencyFormatter.string(from: NSNumber(value: amount))!
    }
    
    static func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0

        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    static func localizedClientCount(_ number: Int) -> String {
        let formated = self.formatNumber(number)
        
        return String.localizedStringWithFormat(NSLocalizedString("Client value", comment: ""), String(formated))
    }
    
}
