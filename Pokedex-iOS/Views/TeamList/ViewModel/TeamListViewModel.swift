//
//  TeamListViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import UIKit
import Combine
import Firebase

protocol TeamListViewModelRepresentable {
    func loadData()
    func didTapItem(model: Team)
    var teamListSubject: PassthroughSubject<[Team], Failure> { get }
}

final class TeamListViewModel<R: AppRouter> {
    var router: R?
    
    private var cancellables = Set<AnyCancellable>()
    private let store: TeamListStore
    let teamListSubject = PassthroughSubject<[Team], Failure>()
    
    private var fetchedTeams = [Team]() {
        didSet {
            teamListSubject.send(fetchedTeams)
        }
    }
    
    init(store: TeamListStore = APIManager()) {
        self.store = store
    }
}

extension TeamListViewModel: TeamListViewModelRepresentable {
    func didTapItem(model: Team) {
        router?.process(route: .showPokemonTeam(model: model))
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser!.uid
        
        let recieved = { (response: [String : Team]) -> Void in
            response.forEach { dict in
                var team: Team = dict.value
                team.id = dict.key
                DispatchQueue.main.async { [unowned self] in
                    fetchedTeams.append(team)
                }
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let failure):
                teamListSubject.send(completion: .failure(failure))
            }
        }
        
        store.readTeams(userId: userId)
            .sink(receiveCompletion: completion, receiveValue: recieved)
            .store(in: &cancellables)
    }
}

