//
//  PokemonDetailViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/12/23.
//

import UIKit
import Combine

protocol PokemonDetailViewModelRepresentable {
    var pokemonDetailSubject: CurrentValueSubject<PokemonDetailBase?, Failure> { get }
    func loadData()
}

final class PokemonDetailViewModel<R: AppRouter> {
    var router: R?
    
    let pokemonDetailSubject = CurrentValueSubject<PokemonDetailBase?, Failure>(nil)
    private var cancellables = Set<AnyCancellable>()
    private let store: PokemonDetailStore
    private let pokemon: Pokemon
    
    init(pokemon: Pokemon, store: PokemonDetailStore = APIManager()) {
        self.store = store
        self.pokemon = pokemon
    }
}

extension PokemonDetailViewModel: PokemonDetailViewModelRepresentable {
    func loadData() {
        let recieved = { (response: PokemonDetailBase) -> Void in
            DispatchQueue.main.async { [unowned self] in
                pokemonDetailSubject.send(response)
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let failure):
                pokemonDetailSubject.send(completion: .failure(failure))
            }
        }
        
        store.readPokemonDetails(pokemon: pokemon)
            .sink(receiveCompletion: completion, receiveValue: recieved)
            .store(in: &cancellables)
    }
}
