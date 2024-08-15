//
//  APIConstant.swift
//  SwiftCurrency
//
//  Created by Tushar on 14/08/24.
//

import Foundation

struct APIConstants {
    
    static let baseURL = "https://openexchangerates.org/api"
    static let appID = "39c0a83ab80f404d832defe5abef8e4c"
    
   
    struct Endpoints {
        static let latestExchangeRates = "/latest.json"
        static let availableCurrencies = "/currencies.json"
    }
    
    static var latestExchangeRatesURL: String {
        return "\(baseURL)\(Endpoints.latestExchangeRates)?app_id=\(appID)"
    }
    
    static var availableCurrenciesURL: String {
        return "\(baseURL)\(Endpoints.availableCurrencies)?app_id=\(appID)"
    }
}
