//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateExchangeRate(_ exchangeRateData: CoinManagerModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "?apikey=835519FB-CDD1-4A4E-B36F-46BC06995E3D"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let cryptoArray = ["BTC","NIS","LTC","VEN","XRP","ETH","TRI","PND","EUC","PAK","DOGE"]
    
    var delegate: CoinManagerDelegate?
    
    private func buildURL(fiatCurrency: String, cryptoCurrency: String) -> URL {
        return URL(string: baseURL + "\(cryptoCurrency)/" + "\(fiatCurrency)" + apiKey)!
    }
    
    func getCoinPrice(fiat fc: String, crypto cc: String) {
        let url = buildURL(fiatCurrency: fc, cryptoCurrency: cc)
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
    
    func parseJSON(_ data: Data) -> CoinManagerModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ExchangeRateData.self, from: data)
            return CoinManagerModel(rate: decodedData.rate, fiatCurrency: decodedData.asset_id_quote, cyrptoCurrency: decodedData.asset_id_base)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
