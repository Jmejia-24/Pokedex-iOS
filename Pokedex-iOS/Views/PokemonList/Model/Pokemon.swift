//
//  Pokemon.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import Foundation

struct Pokemon: Codable, Hashable {
    let name: String
    let url: String
}

struct PokemonEntry: Codable, Hashable {
    let pokemon: Pokemon

    enum CodingKeys: String, CodingKey {
        case pokemon = "pokemon_species"
    }
}
