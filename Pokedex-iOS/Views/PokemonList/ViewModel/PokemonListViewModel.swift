//
//  PokemonListViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

protocol PokemonListViewModelRepresentable {
    func loadData()
    func didTapItem(model: Pokemon)
    var pokemonListSubject: PassthroughSubject<[PokemonEntry], Failure> { get }
}

final class PokemonListViewModel<R: AppRouter> {
    var router: R?
    
    let pokemonListSubject = PassthroughSubject<[PokemonEntry], Failure>()
    private var cancellables = Set<AnyCancellable>()
    private let store: PokemonListStore
    private let pokedex: Pokedex
    
    init(pokedex: Pokedex, store: PokemonListStore = APIManager()) {
        self.store = store
        self.pokedex = pokedex
    }
}

extension PokemonListViewModel: PokemonListViewModelRepresentable {
    func didTapItem(model: Pokemon) {
        router?.process(route: .showPokemonDetail(model: model))
    }
    
    func loadData() {
        let recieved = { (response: PokemonResponse) -> Void in
            DispatchQueue.main.async { [unowned self] in
                pokemonListSubject.send(response.pokemonEntry)
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let failure):
                pokemonListSubject.send(completion: .failure(failure))
            }
        }
        
        store.readPokemons(pokedex: pokedex)
            .sink(receiveCompletion: completion, receiveValue: recieved)
            .store(in: &cancellables)
    }
}

