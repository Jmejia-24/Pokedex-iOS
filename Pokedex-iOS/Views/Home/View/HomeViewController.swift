//
//  HomeViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

final class HomeViewController: UICollectionViewController, Spinner {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Region>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Region>
    
    private var subscription: AnyCancellable?
    private let viewModel: HomeViewModelRepresentable
    
    private lazy var sidebarView: SidebarView = {
        let sidebarView = SidebarView(delegate: self)
        sidebarView.sidebarBackgroundColor = .systemBackground
        sidebarView.blurBackgroundEffect = UIBlurEffect(style: .dark)
        sidebarView.dismissesOnSelection = true
        sidebarView.allowsPullToDisplay = true
        sidebarView.shouldPushRootControllerOnDisplay = true
        sidebarView.sidebarViewScreenPercentageWidth = 0.7
        return sidebarView
    }()
    
    private lazy var sideMenuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle.fill"), primaryAction: UIAction { [unowned self] _ in
            sidebarView.show()
        })
        return button
    }()
    
    init(viewModel: HomeViewModelRepresentable) {
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
        navigationController?.isNavigationBarHidden = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = sideMenuButton
        title = "Regions"
        safeAreaLayoutGuideetSafe()
        showSpinner()
        viewModel.loadData()
    }
    
    private func bindUI() {
        subscription = viewModel.regionListSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
                hideSpinner()
            }
        } receiveValue: { [unowned self] regions in
            applySnapshot(regions: regions)
            hideSpinner()
        }
    }
    
    // MARK: Diffable data source
    
    private let registerRegionCell = UICollectionView.CellRegistration<UICollectionViewListCell, Region> { cell, indexPath, region in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = region.name.capitalized
        
        cell.contentConfiguration = configuration
    }
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            collectionView.dequeueConfiguredReusableCell(using: self.registerRegionCell, for: indexPath, item: item)
        }
        return dataSource
    }()
    
    private func applySnapshot(regions: [Region]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(regions, toSection: $0) }
        dataSource.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let region = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didTapItem(model: region)
    }
}

extension HomeViewController {
    static private func generateLayout() -> UICollectionViewCompositionalLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
}

extension HomeViewController: SidebarViewDelegate {
    func sidebarView(didSelectItemAt type: MenuOption) {
        viewModel.sendTo(type)
    }
}
