//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateExchangeRate(_ exchangeRateData: ExchangeRateData)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "?apikey=<apikey>"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    private func buildURL(currency: String) -> URL {
        let url = baseURL + currency + apiKey
        return URL(string: url)!
    }

    func getCoinPrice(for currency: String) {
        let url = buildURL(currency: currency)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode)
                else {
                    return
            }
            
            if let safeData = data {
                if let exchangeData =  self.parseJSON(safeData) {
                    self.delegate?.didUpdateExchangeRate(exchangeData)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> ExchangeRateData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ExchangeRateData.self, from: data)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
