//
//  CurrencyViewModel.swift
//  SwiftCurrency
//
//  Created by Tushar on 14/08/24.
//


import Foundation

class CurrencyViewModel {
    private let userDefaultsManager: UserDefaultsManager
    private let webServiceHelper: WebServiceHelper

    var exchangeRates: [String: Double] = [:] {
        didSet {
            userDefaultsManager.saveExchangeRates(exchangeRates)
        }
    }
    
    var availableCurrencies: [String] = []
    
    var errorMessage: String? {
        didSet {
            onError?(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage ?? "Unknown error"]))
        }
    }
    
    var selectedCurrency: String? {
        didSet {
            convertCurrency()
        }
    }
    
    var convertedAmounts: [String: Double] = [:] {
        didSet {
            onConversionUpdate?()
        }
    }
    
    var onConversionUpdate: (() -> Void)?
    var onDataFetchComplete: (() -> Void)?
    var onDataCleared: (() -> Void)?
    var onError: ((Error) -> Void)?

    init(userDefaultsManager: UserDefaultsManager = UserDefaultsManager.shared, webServiceHelper: WebServiceHelper = WebServiceHelper.shared) {
        self.userDefaultsManager = userDefaultsManager
        self.webServiceHelper = webServiceHelper
    }
    
    func fetchInitialData() {
        if userDefaultsManager.shouldRefreshData() {
            clearData() 
            fetchLatestExchangeRates {
                self.fetchAvailableCurrencies {
                    self.onDataFetchComplete?()
                }
            }
        } else {
            self.exchangeRates = userDefaultsManager.loadExchangeRates() ?? [:]
            self.availableCurrencies = Array(self.exchangeRates.keys).sorted()
            onDataFetchComplete?()
        }
    }

    private func clearData() {
        exchangeRates.removeAll()
        availableCurrencies.removeAll()
        convertedAmounts.removeAll()
        selectedCurrency = nil
        userDefaultsManager.clearData()
        onDataCleared?()
    }
    
    private func fetchLatestExchangeRates(completion: @escaping () -> Void) {
        webServiceHelper.get(url: APIConstants.latestExchangeRatesURL, parameters: nil, headers: nil) { [weak self] (result: Result<LatestExchangeModel, Error>) in
            switch result {
            case .success(let response):
                print("Success fetching rates: \(response.rates)")
                self?.exchangeRates = response.rates
                completion()
            case .failure(let error):
                print("Failed to fetch rates with error: \(error)")
                self?.handleError(error)
                completion()
            }
        }
    }

    
    private func fetchAvailableCurrencies(completion: @escaping () -> Void) {
        webServiceHelper.getString(url: APIConstants.availableCurrenciesURL, parameters: nil, headers: nil) { [weak self] (result: Result<LatestCurrenciesModel, Error>) in
            switch result {
            case .success(let response):
                self?.availableCurrencies = Array(response.currencies.keys).sorted()
                completion()
            case .failure(let error):
                self?.handleError(error)
                completion()
            }
        }
    }
    
    func convertCurrency(amount: Double = 1.0) {
        guard let selectedCurrency = selectedCurrency, let baseRate = exchangeRates[selectedCurrency] else {
            convertedAmounts = [:]
            return
        }
        
        convertedAmounts = exchangeRates.mapValues { rate in
            return (amount / baseRate) * rate
        }
    }
    
    private func handleError(_ error: Error) {
        self.errorMessage = error.localizedDescription
        print("Error: \(error.localizedDescription)")
    }
}
