//
//  RegionResponse.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import Foundation

struct RegionResponse: Codable {
    let count: Int
    let results: [Region]
}
