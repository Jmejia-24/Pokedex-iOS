//
//  LogInViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

class LogInViewController: UIViewController {

    private var subscription: AnyCancellable?
    private let viewModel: LogInViewModelRepresentable
    
    init(viewModel: LogInViewModelRepresentable) {
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
        
    }
    
    private func bindUI() {
        subscription = viewModel.errorSubject.sink { _ in
        } receiveValue: { [unowned self] error in
            presentAlert(with: error)
        }
    }
    
    @IBAction func didTapGoogleButton(_ sender: Any) {
        viewModel.googleSignIn(self)
    }
}
