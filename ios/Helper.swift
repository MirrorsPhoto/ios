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
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.maximumFractionDigits = 0

        return currencyFormatter.string(from: NSNumber(value: number))!
    }
    
}
