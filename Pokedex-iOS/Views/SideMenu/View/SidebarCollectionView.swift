//
//  SidebarCollectionView.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/14/23.
//

import UIKit

internal class SidebarCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: Self.generateLayout())
        setupInitialState()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialState() {
        translatesAutoresizingMaskIntoConstraints = false
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        bounces = false
    }
    
    static private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
}
