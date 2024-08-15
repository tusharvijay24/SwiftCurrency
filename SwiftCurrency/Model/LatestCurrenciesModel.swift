//
//  LatestCurrenciesModel.swift
//  SwiftCurrency
//
//  Created by Tushar on 14/08/24.
//


import Foundation

struct LatestCurrenciesModel: Codable {
    let currencies: [String: String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        currencies = try container.decode([String: String].self)
    }
}

