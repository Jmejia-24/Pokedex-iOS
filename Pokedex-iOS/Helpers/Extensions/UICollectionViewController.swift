//
//  UICollectionViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/13/23.
//

import UIKit

extension UICollectionViewController {
    func safeAreaLayoutGuideetSafe() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }
}
