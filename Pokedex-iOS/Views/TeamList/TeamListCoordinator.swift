//
//  TeamListCoordinator.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import UIKit

final class TeamListCoordinator<R: AppRouter> {
    let router: R
    
    private lazy var primaryViewController: UIViewController = {
        let viewModel = TeamListViewModel<R>()
        viewModel.router = router
        let viewController = TeamListViewController(viewModel: viewModel)
        return viewController
    }()
    
    init(router: R) {
        self.router = router
    }
}

extension TeamListCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}
