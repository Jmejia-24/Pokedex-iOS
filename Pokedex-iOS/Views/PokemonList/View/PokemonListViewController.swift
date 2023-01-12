//
//  PokemonListViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

final class PokemonListViewController: UICollectionViewController {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PokemonEntry>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PokemonEntry>
    
    private var subscription: AnyCancellable?
    private let viewModel: PokemonListViewModelRepresentable
    
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
        title = "Pokemos"
        viewModel.loadData()
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
    
    // MARK: Diffable data source
    
    private let registerPokemonCell = UICollectionView.CellRegistration<UICollectionViewListCell, PokemonEntry> { cell, indexPath, pokemonEntry in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = pokemonEntry.pokemon.name.capitalized
        
        cell.contentConfiguration = configuration
    }
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            collectionView.dequeueConfiguredReusableCell(using: self.registerPokemonCell, for: indexPath, item: item)
        }
        return dataSource
    }()
    
    private func applySnapshot(pokemonEntrys: [PokemonEntry]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(pokemonEntrys, toSection: $0) }
        dataSource.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokemon = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didTapItem(model: pokemon.pokemon)
    }
}

extension PokemonListViewController {
    static private func generateLayout() -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.backgroundColor = .white
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
}
