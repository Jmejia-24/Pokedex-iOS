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

final class PokemonListViewController: UICollectionViewController {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PokemonEntry>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PokemonEntry>
    
    private var subscription: AnyCancellable?
    private var viewModel: PokemonListViewModelRepresentable
    
    private var currentMode: Mode = .notAddingTeam
    
    private lazy var addTeamButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "Add Team", primaryAction: UIAction { [unowned self] _ in
            tapAddTeamButton()
        })
        return buttonItem
    }()
    
    private lazy var cancelButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "Cancel", primaryAction: UIAction { [unowned self] _ in
            tapCancelButton()
        })
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
        view.backgroundColor = .white
        title = "Pókemon"
        viewModel.loadData()
        navigationItem.rightBarButtonItems = [addTeamButtonItem, cancelButtonItem]
        cancelButtonItem.isHidden = true
        collectionView.register(PokemonCollectionViewCell.self)
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
        currentMode = currentMode == .addingTeam ? .notAddingTeam : .addingTeam
        switch currentMode {
        case .addingTeam:
            title = ""
            addTeamButtonItem.title = "Done"
            cancelButtonItem.isHidden = false
        case .notAddingTeam:
            title = "Pókemon"
            addTeamButtonItem.title = "Add Team"
            cancelButtonItem.isHidden = true
        }
        reloadData()
    }
    
    private func tapCancelButton() {
        title = "Pókemon"
        viewModel.selectedPokemons.removeAll()
        currentMode = .notAddingTeam
        cancelButtonItem.isHidden = true
        addTeamButtonItem.title = "Add Team"
        reloadData()
    }
    
    // MARK: Diffable data source
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            let cell: PokemonCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            
            let isSelected = self.viewModel.selectedPokemons.contains(where: { $0.name == item.pokemon.name })
            
            cell.performSelected(isSelected, for: self.currentMode)
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
       
        switch currentMode {
        case .addingTeam:
            if let index = viewModel.selectedPokemons.firstIndex(where: { $0.name == pokemon.pokemon.name }) {
                viewModel.selectedPokemons.remove(at: index)
            } else {
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
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.backgroundColor = .white
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
    
}
