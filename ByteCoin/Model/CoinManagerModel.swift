//
//  CoinManagerModel.swift
//  ByteCoin
//
//  Created by James  Farrell on 26/02/2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManagerModel {
    let rate: Double
    let fiatCurrency: String
    let cyrptoCurrency: String
    
    var rateString: String {
        return String.init(format: "%.2f", rate)
    }
    
    var fiatName: String {
        switch fiatCurrency {
        case "AUD", "CAD", "HKD", "NZD", "USD":
            return "dollarsign.circle.fill"
        case "CNY":
            return "yensign.circle.fill"
        case "EUR":
            return "eurosign.circle.fill"
        case "GBP":
            return "sterlingsign.circle.fill"
        case "INR":
            return "indianrupeesign.circle.fill"
        case "JPY":
            return "yensign.circle.fill"
        case "RUB":
            return "rublesign.circle.fill"
        default:
            return "bolt.circle.fill"
        }
    }
}
