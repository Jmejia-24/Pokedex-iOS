//
//  Pokemon.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import Foundation

struct Pokemon: Codable, Identifiable {
    let id = UUID().uuidString
    let name: String
    let url: String
}

extension Pokemon: Hashable {
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

struct PokemonEntry: Codable, Identifiable {
    let id = UUID().uuidString
    var pokemon: Pokemon
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case pokemon = "pokemon_species"
    }
}

extension PokemonEntry: Hashable {
    static func == (lhs: PokemonEntry, rhs: PokemonEntry) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
