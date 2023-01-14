//
//  TeamListViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import UIKit
import Combine
import FirebaseDatabase
import Firebase

protocol TeamListViewModelRepresentable {
    func loadData()
    func didTapItem(model: Team)
}

final class TeamListViewModel<R: AppRouter> {
    var router: R?
    
    private var database: DatabaseReference {
        Database.database().reference()
    }
    
    init() {
    }
}

extension TeamListViewModel: TeamListViewModelRepresentable {
    func didTapItem(model: Team) {
        
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser!.uid
        database.child(userId).child("teams").observeSingleEvent(of: .value, with: { teams in
            if let value = teams as? [String: Any],
               let title = value["title"] as? String {
                print(title)
            }
            
        }) { error in
            print(error.localizedDescription)
        }
    }
}

