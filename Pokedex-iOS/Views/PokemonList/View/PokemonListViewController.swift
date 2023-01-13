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
    
    var selectedCells:[Int] = []
    var pokemonModel = [PokemonEntry]()
    
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
        title = "Pókemon"
        viewModel.loadData()
        navigationItem.rightBarButtonItem = editButtonItem
        collectionView.allowsMultipleSelectionDuringEditing = true
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
        
        let customAccessory = UICellAccessory.CustomViewConfiguration(
          customView: UIImageView(image: UIImage(systemName: "checkmark.circle")),
          placement: .trailing(displayed: .always))

        cell.accessories = [.customView(configuration: customAccessory)]
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.isEditing = editing
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
       
        if !isEditing {
            viewModel.didTapItem(model: pokemon.pokemon)
        }
        
        else {
            if self.selectedCells.contains(indexPath.item) {
                var index = self.selectedCells.firstIndex(of: indexPath.item)
                self.selectedCells.remove(at: index!)
                
            }
            else {
                self.selectedCells.append(indexPath.item)
               
              
            }
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([pokemon])
//        let selectedData = pokemonModel[indexPath.item]
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
}

extension PokemonListViewController {
    static private func generateLayout() -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.backgroundColor = .white
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
    
}
