//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var cryptoPicker: UIPickerView!
    @IBOutlet weak var currencySymbol: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        cryptoPicker.dataSource = self
        cryptoPicker.delegate = self
        
        coinManager.delegate = self
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == currencyPicker {
            return coinManager.currencyArray.count
        }
        if pickerView == cryptoPicker {
            return coinManager.cryptoArray.count
        }
        return 1
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == currencyPicker {
            return coinManager.currencyArray[row]
        }
        if pickerView == cryptoPicker {
            return coinManager.cryptoArray[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(fiat: coinManager.currencyArray[currencyPicker.selectedRow(inComponent: 0)], crypto: coinManager.cryptoArray[cryptoPicker.selectedRow(inComponent: 0)])
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateExchangeRate(_ exchangeRateData: CoinManagerModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = exchangeRateData.rateString
            self.currencyLabel.text = exchangeRateData.fiatCurrency
            self.currencySymbol.image = UIImage(systemName: exchangeRateData.fiatName)
            self.infoLabel.text = "1 \(exchangeRateData.cyrptoCurrency) to \(exchangeRateData.fiatCurrency) Exchange Rate"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

