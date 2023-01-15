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
        super.init(collectionViewLayout: UICollectionViewLayout())
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
        collectionView.collectionViewLayout = generateLayout()
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
    
    private func deleteTeam(indexPath: IndexPath) {
        guard let team = dataSource.itemIdentifier(for: indexPath) else { return }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([team])
        dataSource.apply(snapshot)
    }
    
    private func editTeam(indexPath: IndexPath) {
        guard let team = dataSource.itemIdentifier(for: indexPath) else { return }
        UIAlertController.Builder()
            .withTitle("Update Team Title")
            .withTextField(true)
            .withButton(style: .destructive, title: "Cancel")
            .withButton(title: "Update team") { [unowned self] alert in
                guard let title = alert.textFields?.first?.text,
                      !title.isEmpty else {
                    presentAlert(with: "Title cannot be empty")
                    return
                }
            }
            .present(in: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pokedex = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didTapItem(model: pokedex)
    }
}

extension TeamListViewController {
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, completion in
                deleteTeam(indexPath: indexPath)
                completion(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            
            let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, completion in
                editTeam(indexPath: indexPath)
                completion(true)
            }
            editAction.image = UIImage(systemName: "pencil.circle.fill")
            editAction.backgroundColor = .blue
            
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        }
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
}
