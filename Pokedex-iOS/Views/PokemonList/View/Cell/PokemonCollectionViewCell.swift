//
//  PokemonCollectionViewCell.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/13/23.
//

import UIKit

final class PokemonCollectionViewCell: UICollectionViewCell, NibLoadable {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkMark.image = UIImage(systemName: "circle")
    }
    
    func configure(_ pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
    }
    
    func performSelected(_ isSelected: Bool, for mode: Mode) {
        switch mode {
        case .addingTeam:
            DispatchQueue.main.async { [unowned self] in
                checkMark.image = UIImage(systemName: isSelected ? "checkmark.circle" : "circle")
                checkMark.isHidden = false
            }
        case .notAddingTeam:
            DispatchQueue.main.async { [unowned self] in
                checkMark.isHidden = true
            }
        }
    }
}
