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
    func updateTitleTeam(team: Team)
    func deleteTeam(team: Team)
    var teamListSubject: PassthroughSubject<[Team], Failure> { get }
    var errorSubject: PassthroughSubject<String, Error> { get }
}

final class TeamListViewModel<R: AppRouter> {
    var router: R?
    
    private var cancellables = Set<AnyCancellable>()
    private let store: TeamListStore
    private let userId = Auth.auth().currentUser!.uid
    let teamListSubject = PassthroughSubject<[Team], Failure>()
    let errorSubject = PassthroughSubject<String, Error>()
    
    private var fetchedTeams = [Team]() {
        didSet {
            teamListSubject.send(fetchedTeams.sorted())
        }
    }
    
    init(store: TeamListStore = APIManager()) {
        self.store = store
    }
    
    private func reloadData() {
        fetchedTeams = []
        loadData()
    }
}

extension TeamListViewModel: TeamListViewModelRepresentable {
    func didTapItem(model: Team) {
        router?.process(route: .showPokemonTeam(model: model))
    }
    
    func loadData() {
        let recieved = { (response: [String : Team]) -> Void in
            response.values.forEach { value in
                DispatchQueue.main.async { [unowned self] in
                    fetchedTeams.append(value as Team)
                }
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let failure):
                errorSubject.send(failure.localizedDescription)
            }
        }
        
        store.readTeams(userId: userId)
            .sink(receiveCompletion: completion, receiveValue: recieved)
            .store(in: &cancellables)
    }
    
    func updateTitleTeam(team: Team) {
        let recieved = { [unowned self] (response: Bool) -> Void in
            if response {
                reloadData()
            } else {
                errorSubject.send("The title of this team could not be updated")
            }
        }
        
        store.updateTitleTeam(userId: userId, team: team)
            .sink(receiveCompletion: { _ in}, receiveValue: recieved)
            .store(in: &cancellables)
    }
    
    func deleteTeam(team: Team) {
        let recieved = { [unowned self] (response: Bool) -> Void in
            if response {
                reloadData()
            } else {
                errorSubject.send("Could not delete \(team.title)")
            }
        }
        
        store.deleteTeam(userId: userId, team: team)
            .sink(receiveCompletion: { _ in}, receiveValue: recieved)
            .store(in: &cancellables)
    }
}
