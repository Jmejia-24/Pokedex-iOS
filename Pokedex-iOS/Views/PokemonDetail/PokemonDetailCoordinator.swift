//
//  PokemonDetailCoordinator.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/12/23.
//

import UIKit

final class PokemonDetailCoordinator<R: AppRouter> {
    let router: R
    var model: Pokemon
    
    private lazy var primaryViewController: UIViewController = {
        let viewModel = PokemonDetailViewModel<R>(pokemon: model)
        viewModel.router = router
        let viewController = PokemonDetailViewController(viewModel: viewModel)
        return viewController
    }()
    
    init(model: Pokemon, router: R) {
        self.router = router
        self.model = model
    }
}

extension PokemonDetailCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}

