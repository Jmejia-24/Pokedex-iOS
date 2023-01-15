//
//  PokemonDetailViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/12/23.
//

import UIKit
import Combine

final class PokemonDetailViewController: UIViewController, Spinner {
    
    @IBOutlet private var pokemonImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    private var subscription: AnyCancellable?
    private let viewModel: PokemonDetailViewModelRepresentable
    
    init(viewModel: PokemonDetailViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        showSpinner()
        viewModel.loadData()
    }
    
    private func bindUI() {
        subscription = viewModel.pokemonDetailSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
                hideSpinner()
            }
        } receiveValue: { [unowned self] pokemonDetail in
            setPokemonInfo(pokemonDetail)
            hideSpinner()
        }
    }
    
    private func setPokemonInfo(_ pokemon: PokemonDetailBase?) {
        guard let pokemon = pokemon else { return }
        
        titleLabel.text = pokemon.name.uppercased()
        numberLabel.text = "\(pokemon.id)"
        let texts = pokemon.flavorTextEntries.filter { $0.language?.name == "en" }
        descriptionLabel.text = texts.first?.flavorText
        typeLabel.text = pokemon.eggGroups.compactMap({ $0.name.capitalized }).joined(separator: ", ")
        
        Task {
            let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png"
            pokemonImageView.image = await ImageCacheStore.shared.getCacheImage(for: imageURL)
        }
    }
}
