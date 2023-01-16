//
//  PokemonResponse.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import Foundation

struct PokemonResponse: Codable {
    let id: Int
    let name: String?
    let region: Region
    let pokemonEntry: [PokemonEntry]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case region
        case pokemonEntry = "pokemon_entries"
    }
}
