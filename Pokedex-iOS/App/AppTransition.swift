//
//  AppTransition.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import Foundation

enum AppTransition {
    
    case showLogIn
    
    var hasState: Bool {
        /// If some transitions need to have state - perform case match logic here
        /// Generally prefer stateless
        false
    }
    
    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        switch self {
        case .showLogIn: return LogInCoordinator(router: router)
        }
    }
}

extension AppTransition: Hashable {
    
    var identifier: String {
        switch self {
        case .showLogIn: return "showLogIn"
        }
    }
    
    static func == (lhs: AppTransition, rhs: AppTransition) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
