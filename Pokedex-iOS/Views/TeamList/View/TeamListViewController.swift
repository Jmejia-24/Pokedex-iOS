//
//  TeamListViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import UIKit
import Combine

final class TeamListViewController: UICollectionViewController {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Team>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Team>
    
    private var subscription: AnyCancellable?
    private let viewModel: TeamListViewModelRepresentable
    
    init(viewModel: TeamListViewModelRepresentable) {
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
        title = "Teams"
        safeAreaLayoutGuideetSafe()
        viewModel.loadData()
    }
    
    private func bindUI() {
        subscription = viewModel.teamListSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
            }
        } receiveValue: { [unowned self] teams in
            applySnapshot(teams: teams)
        }
    }
    
    // MARK: Diffable data source
    
    private let registerPokedexCell = UICollectionView.CellRegistration<UICollectionViewListCell, Team> { cell, indexPath, team in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = team.title.capitalized
        
        cell.contentConfiguration = configuration
    }
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            collectionView.dequeueConfiguredReusableCell(using: self.registerPokedexCell, for: indexPath, item: item)
        }
        return dataSource
    }()
    
    private func applySnapshot(teams: [Team]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(teams, toSection: $0) }
        dataSource.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokedex = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didTapItem(model: pokedex)
    }
}

extension TeamListViewController {
    static private func generateLayout() -> UICollectionViewCompositionalLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
}
