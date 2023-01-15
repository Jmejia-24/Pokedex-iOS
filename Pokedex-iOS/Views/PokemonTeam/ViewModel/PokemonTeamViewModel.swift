//
//  PokemonTeamViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import UIKit

protocol PokemonTeamViewModelRepresentable {
    var team: Team { get }
    func didTapItem(model: Pokemon)
}

final class PokemonTeamViewModel<R: AppRouter> {
    var router: R?
    let team: Team
    
    init(team: Team) {
        self.team = team
    }
}

extension PokemonTeamViewModel: PokemonTeamViewModelRepresentable {
    func didTapItem(model: Pokemon) {
        router?.process(route: .showPokemonDetail(model: model))
    }
}
