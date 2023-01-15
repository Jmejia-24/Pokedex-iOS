//
//  HomeViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

protocol HomeViewModelRepresentable {
    var regionListSubject: PassthroughSubject<[Region], Failure> { get }
    func loadData()
    func didTapItem(model: Region)
    func sendTo(_ type: MenuOption)
}

final class HomeViewModel<R: AppRouter> {
    var router: R?
    
    let regionListSubject = PassthroughSubject<[Region], Failure>()
    private var cancellables = Set<AnyCancellable>()
    private let store: HomeListStore
    
    init(store: HomeListStore = APIManager()) {
        self.store = store
    }
}

extension HomeViewModel: HomeViewModelRepresentable {
    func sendTo(_ type: MenuOption) {
        switch type {
        case .teams:
            router?.process(route: .shoWTeamList)
        case .logOut:
            router?.exit()
        default:
            break
        }
    }
    
    func didTapItem(model: Region) {
        router?.process(route: .showPokedexes(model: model))
    }
    
    func loadData() {
        let recieved = { (response: RegionResponse) -> Void in
            DispatchQueue.main.async { [unowned self] in
                regionListSubject.send( response.results)
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let failure):
                regionListSubject.send(completion: .failure(failure))
            }
        }
        
        store.readRegionList()
            .sink(receiveCompletion: completion, receiveValue: recieved)
            .store(in: &cancellables)
    }
}
