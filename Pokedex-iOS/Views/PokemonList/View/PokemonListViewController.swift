//
//  PokemonListViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine
import FirebaseDatabase
import Firebase

enum Mode {
    case addingTeam
    case notAddingTeam
}

final class PokemonListViewController: UICollectionViewController {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PokemonEntry>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PokemonEntry>
    
    private var subscription: AnyCancellable?
    private var viewModel: PokemonListViewModelRepresentable
    
    private var database: DatabaseReference {
        Database.database().reference()
    }
    
    private lazy var addTeamButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "Add Team", primaryAction: UIAction { [unowned self] _ in
            tapAddTeamButton()
        })
        buttonItem.tintColor = .blue
        return buttonItem
    }()
    
    private lazy var doneButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "Done", primaryAction: UIAction { [unowned self] _ in
            tapDoneButton()
        })
        buttonItem.tintColor = .systemGreen
        return buttonItem
    }()
    
    private lazy var cancelButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "Cancel", primaryAction: UIAction { [unowned self] _ in
            finishAddingTeam()
        })
        buttonItem.tintColor = .red
        return buttonItem
    }()
    
    init(viewModel: PokemonListViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: Self.generateLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindUI()
    }
    
    
    private func setUI() {
        title = "Pókemon"
        
        viewModel.loadData()
        navigationItem.rightBarButtonItems = [addTeamButtonItem, doneButtonItem, cancelButtonItem]
        cancelButtonItem.isHidden = true
        doneButtonItem.isHidden = true
        collectionView.register(PokemonCollectionViewCell.self)
        safeAreaLayoutGuideetSafe()
    }
    
    private func bindUI() {
        subscription = viewModel.pokemonListSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
            }
        } receiveValue: { [unowned self] pokemonEntrys in
            applySnapshot(pokemonEntrys: pokemonEntrys)
        }
    }
    
    private func tapAddTeamButton() {
        viewModel.currentMode = .addingTeam
        title = "Team"
        cancelButtonItem.isHidden = false
        doneButtonItem.isHidden = false
        addTeamButtonItem.isHidden = true
        reloadData()
    }
    
    private func tapDoneButton() {
        addNameTeam()
    }
    
    private func finishAddingTeam() {
        viewModel.currentMode = .notAddingTeam
        title = "Pókemon"
        viewModel.selectedPokemons.removeAll()
        
        cancelButtonItem.isHidden = true
        doneButtonItem.isHidden = true
        addTeamButtonItem.isHidden = false
        reloadData()
    }
    
    private func addNameTeam() {
        if viewModel.selectedPokemons.count >= 3 && viewModel.selectedPokemons.count <= 6 {
            UIAlertController.Builder()
                .withTitle("Add Team Title")
                .withTextField(true)
                .withButton(style: .destructive, title: "Cancel")
                .withButton(title: "Save team") { [unowned self] alert in
                    guard let title = alert.textFields?.first?.text,
                          !title.isEmpty else {
                        presentAlert(with: "Title cannot be empty")
                        return
                    }
                    
                    let userId = Auth.auth().currentUser!.uid
                    let teamId = UUID().uuidString
                    
                    let dict = viewModel.selectedPokemons.compactMap { $0.getParentDict }
                    
                    database.child(userId).child("teams").child(teamId).setValue([
                        "title": title,
                        "pokemons": dict
                    ])
                    
                    finishAddingTeam()
                }
                .present(in: self)
        } else {
            presentAlert(with: "The team must contain 3 to 6 pokemons")
        }
    }
    
    // MARK: Diffable data source
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            let cell: PokemonCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            
            let isSelected = self.viewModel.selectedPokemons.contains(where: { $0.name == item.pokemon.name })
            
            cell.performSelected(isSelected, for: self.viewModel.currentMode)
            cell.configure(item.pokemon)
            
            return cell
        }
        return dataSource
    }()
    
    private func applySnapshot(pokemonEntrys: [PokemonEntry]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(pokemonEntrys, toSection: $0) }
        dataSource.apply(snapshot)
    }
    
    private func reloadData() {
        DispatchQueue.main.async { [unowned self] in
            collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokemon = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch viewModel.currentMode {
        case .addingTeam:
            if let index = viewModel.selectedPokemons.firstIndex(where: { $0.name == pokemon.pokemon.name }) {
                viewModel.selectedPokemons.remove(at: index)
            } else if viewModel.selectedPokemons.count <= 5 {
                viewModel.selectedPokemons.append(pokemon.pokemon)
            }
            reloadData()
        case .notAddingTeam:
            viewModel.didTapItem(model: pokemon.pokemon)
        }
    }
}

extension PokemonListViewController {
    static private func generateLayout() -> UICollectionViewCompositionalLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
}
