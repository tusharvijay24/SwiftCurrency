//
//  LatestExhangeModel.swift
//  SwiftCurrency
//
//  Created by Tushar on 14/08/24.
//

import Foundation

struct LatestExchangeModel: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}
