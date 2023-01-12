//
//  PokedexListCoordinator.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/12/23.
//

import UIKit

final class PokedexListCoordinator<R: AppRouter> {
    let router: R
    var model: Region
    
    private lazy var primaryViewController: UIViewController = {
        let viewModel = PokedexListViewModel<R>(region: model)
        viewModel.router = router
        let viewController = PokedexListViewController(viewModel: viewModel)
        return viewController
    }()
    
    init(model: Region, router: R) {
        self.router = router
        self.model = model
    }
}

extension PokedexListCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}
