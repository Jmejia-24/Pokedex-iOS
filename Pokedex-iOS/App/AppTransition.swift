//
//  AppTransition.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import Foundation

enum AppTransition {
    
    case showLogIn
    case showHome
    case showPokedexes(model: Region)
    case showPokemons(model: Pokedex)
    
    var hasState: Bool {
        /// If some transitions need to have state - perform case match logic here
        /// Generally prefer stateless
        false
    }
    
    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        switch self {
        case .showLogIn: return LogInCoordinator(router: router)
        case .showHome: return HomeCoordinator(router: router)
        case .showPokedexes(let model): return PokedexListCoordinator(model: model, router: router)
        case .showPokemons(let model): return PokemonListCoordinator(model: model, router: router)
        }
    }
}

extension AppTransition: Hashable {
    
    var identifier: String {
        switch self {
        case .showLogIn: return "showLogIn"
        case .showHome: return "showHome"
        case .showPokemons: return "showPokemons"
        case .showPokedexes: return "showPokedexesJ"
        }
    }
    
    static func == (lhs: AppTransition, rhs: AppTransition) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
