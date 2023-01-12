//
//  HomeViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

protocol HomeViewModelRepresentable {
    func loadData()
    var regionListSubject: PassthroughSubject<[Region], Failure> { get }
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
