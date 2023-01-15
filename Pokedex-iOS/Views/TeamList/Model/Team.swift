//
//  Team.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import Foundation

struct Team: Codable, Identifiable {
    let id = UUID().uuidString
    var key: String?
    var title: String
    var pokemons: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        case title
        case pokemons
    }
}

extension Team: Hashable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

extension Team: Comparable {
    static func <(lhs: Team, rhs: Team) -> Bool {
        lhs.title < rhs.title
    }
}
