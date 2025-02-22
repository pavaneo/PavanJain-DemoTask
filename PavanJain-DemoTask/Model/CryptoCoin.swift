//
//  Coin.swift
//  Pavanjain-Task
//
//  Created by Pavan Kumar J on 02/12/24.
//

import Foundation

/// Struct CryptoCoin
struct CryptoCoin: Decodable {
    let name: String
    let symbol: String
    let type: String
    let isActive: Bool
    let isNew: Bool

    enum CodingKeys: String, CodingKey {
        case name, symbol, type
        case isActive = "is_active"
        case isNew = "is_new"
    }
}
