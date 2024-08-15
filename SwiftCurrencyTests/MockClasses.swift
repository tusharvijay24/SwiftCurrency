//
//  MockClasses.swift
//  CurrencyConversionTests
//
//  Created by Tushar on 15/08/24.
//

import Foundation
@testable import SwiftCurrency
import Alamofire

class MockUserDefaultsManager: UserDefaultsManager {
    var shouldRefreshDataResult: Bool = true
    var loadExchangeRatesResult: [String: Double]? = nil
    
    override func shouldRefreshData() -> Bool {
        return shouldRefreshDataResult
    }
    
    override func loadExchangeRates() -> [String: Double]? {
        return loadExchangeRatesResult
    }
}

class MockWebServiceHelper: WebServiceHelper {
    var exchangeRatesResult: [String: Double]? = nil
    var shouldReturnError: Bool = false
    
    override func get<T>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if shouldReturnError {
            let error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "TestError"])
            completion(.failure(error))
        } else if let exchangeRates = exchangeRatesResult as? T {
            completion(.success(exchangeRates))
        } else {
            let error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "TestError"])
            completion(.failure(error))
        }
    }
}
