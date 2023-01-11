//
//  LogInViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit

protocol LogInViewModelRepresentable {
}

final class LogInViewModel<R: AppRouter> {
    var router: R?
    
    init() {
    }
    
}

extension LogInViewModel: LogInViewModelRepresentable { }
