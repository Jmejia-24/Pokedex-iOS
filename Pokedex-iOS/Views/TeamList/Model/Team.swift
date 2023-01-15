//
//  Team.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import Foundation

struct Team: Codable, Hashable {
    var id: String?
    var title: String
    var pokemons: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        case title
        case pokemons
    }
}
