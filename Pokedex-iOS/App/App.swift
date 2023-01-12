//
//  App.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit

final class App {
    var navigationController = UINavigationController()
    private var coordinatorRegister: [AppTransition: Coordinator] = [:]
}

extension App: Coordinator {
    func start() {
        process(route: .showHome)
    }
}

extension App: AppRouter {
    
    func exit() {
        /// In this Router context - the only exit left is the main screen.
        /// Logout - clean tokens - local cache - offline database if needed etc.
        
        navigationController.popToRootViewController(animated: true)
    }
    
    func process(route: AppTransition) {
        let coordinator = route.hasState ? coordinatorRegister[route] : route.coordinatorFor(router: self)
        coordinator?.start()
    }
}
