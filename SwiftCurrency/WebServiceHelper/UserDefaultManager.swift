//
//  UserDefaultManager.swift
//  SwiftCurrency
//
//  Created by Tushar on 15/08/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let exchangeRatesKey = "exchangeRatesKey"
    private let lastFetchKey = "lastFetchKey"
    
    init() {}
    
    
    func saveExchangeRates(_ rates: [String: Double]) {
        UserDefaults.standard.set(rates, forKey: exchangeRatesKey)
        UserDefaults.standard.set(Date(), forKey: lastFetchKey)
    }
    
    
    func loadExchangeRates() -> [String: Double]? {
        return UserDefaults.standard.dictionary(forKey: exchangeRatesKey) as? [String: Double]
    }
    
    func loadLastFetchDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastFetchKey) as? Date
    }
    
    func shouldRefreshData() -> Bool {
        if let lastFetch = loadLastFetchDate() {
            return Date().timeIntervalSince(lastFetch) > 1800 
        }
        return true
    }
    
    func clearData() {
        UserDefaults.standard.removeObject(forKey: exchangeRatesKey)
        UserDefaults.standard.removeObject(forKey: lastFetchKey)
    }
}
