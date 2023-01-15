//
//  LogInViewController.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

class LogInViewController: UIViewController, Spinner {

    private var subscription: AnyCancellable?
    private var viewModel: LogInViewModelRepresentable
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideSpinner()
    }
    
    private func setUI() {
        navigationController?.isNavigationBarHidden = true
        viewModel.delegate = self
    }
    
    @IBAction func didTapGoogleButton(_ sender: Any) {
        showSpinner()
        viewModel.googleSignIn(self)
    }
}

extension LogInViewController: LogInViewModelDelegate {
    func success() {
        hideSpinner()
    }
    
    func error(_ errorMessage: String) {
        hideSpinner()
        presentAlert(with: errorMessage)
    }
}
