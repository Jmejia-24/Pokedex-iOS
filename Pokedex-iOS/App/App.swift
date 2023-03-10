//
//  App.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import GoogleSignIn
import FacebookLogin

final class App {
    var navigationController = UINavigationController()
    private var coordinatorRegister: [AppTransition: Coordinator] = [:]
}

extension App: Coordinator {
    func start() {
        
        var isSession: Bool {
            !UserDefaultsManager.shared.provider.isEmpty
        }
        
        process(route: isSession ? .showHome : .showLogIn)
    }
}

extension App: AppRouter {
    
    func exit() {
        /// In this Router context - the only exit left is the main screen.
        /// Logout - clean tokens - local cache - offline database if needed etc.
        
        switch UserDefaultsManager.shared.provider {
        case Provider.google.rawValue:
            GIDSignIn.sharedInstance.signOut()
        case Provider.facebook.rawValue:
            LoginManager().logOut()
        default:
            break
        }
        
        navigationController.popToRootViewController(animated: true)
        process(route: .showLogIn)
    }
    
    func process(route: AppTransition) {
        let coordinator = route.hasState ? coordinatorRegister[route] : route.coordinatorFor(router: self)
        coordinator?.start()
    }
}
