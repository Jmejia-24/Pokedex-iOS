//
//  PokemonDetailBase.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/12/23.
//

import Foundation

struct PokemonDetailBase: Codable {
    let eggGroups: [Group]
    let flavorTextEntries: [FlavorText]
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case eggGroups = "egg_groups"
        case flavorTextEntries = "flavor_text_entries"
        case id
        case name
    }
}
