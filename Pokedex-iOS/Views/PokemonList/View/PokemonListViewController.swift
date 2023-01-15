//
//  PokemonListViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

enum Mode {
    case addingTeam
    case notAddingTeam
}

final class PokemonListViewController: UICollectionViewController, Spinner {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PokemonEntry>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PokemonEntry>
    
    private var subscription: AnyCancellable?
    private var viewModel: PokemonListViewModelRepresentable
    
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
        navigationItem.rightBarButtonItems = [addTeamButtonItem, doneButtonItem, cancelButtonItem]
        safeAreaLayoutGuideetSafe()
        collectionView.register(PokemonCollectionViewCell.self)
        cancelButtonItem.isHidden = true
        doneButtonItem.isHidden = true
        showSpinner()
        viewModel.loadData()
    }
    
    private func bindUI() {
        subscription = viewModel.pokemonListSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
                hideSpinner()
            }
        } receiveValue: { [unowned self] pokemonEntrys in
            applySnapshot(pokemonEntrys: pokemonEntrys)
            hideSpinner()
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
                    
                    viewModel.saveTeam(title: title)
                    
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
