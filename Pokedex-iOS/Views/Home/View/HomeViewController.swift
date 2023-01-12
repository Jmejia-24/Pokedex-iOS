//
//  HomeViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit

final class HomeViewController: UICollectionViewController {
    
    private let viewModel: HomeViewModelRepresentable
    
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
    }
    
    private func setUI() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        title = "Home"
    }
}

extension HomeViewController {
    static private func generateLayout() -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.backgroundColor = .white
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
}
