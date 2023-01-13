//
//  FlavorText.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/12/23.
//

import Foundation

struct FlavorText: Codable {
    let flavorText: String?
    let language: Language?

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language = "language"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flavorText = try values.decodeIfPresent(String.self, forKey: .flavorText)
        language = try values.decodeIfPresent(Language.self, forKey: .language)
    }

}
