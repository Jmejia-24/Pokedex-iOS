//
//  Option.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import Foundation

struct Option: Identifiable, Hashable {
    let id: Int
    var name: String
    var icon: String
    var type: MenuOption
}
