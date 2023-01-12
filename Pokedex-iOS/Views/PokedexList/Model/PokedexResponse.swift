//
//  PokedexResponse.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/12/23.
//

import Foundation

struct PokedexResponse: Codable {
    let id: Int
    let name: String
    let pokedexes: [Pokedex]
}
