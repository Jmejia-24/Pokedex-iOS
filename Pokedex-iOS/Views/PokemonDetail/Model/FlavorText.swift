//
//  FlavorText.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/12/23.
//

import Foundation

struct FlavorText: Codable {
    let flavorText: String
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
    }
}
