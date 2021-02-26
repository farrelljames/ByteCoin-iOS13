//
//  ExchangeRateData.swift
//  ByteCoin
//
//  Created by James  Farrell on 26/02/2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct ExchangeRateData: Decodable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
