//
//  HomeViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit

protocol HomeViewModelRepresentable {
    
}

final class HomeViewModel<R: AppRouter> {
    var router: R?
    
    init() {
        
    }
}

extension HomeViewModel: HomeViewModelRepresentable { }
