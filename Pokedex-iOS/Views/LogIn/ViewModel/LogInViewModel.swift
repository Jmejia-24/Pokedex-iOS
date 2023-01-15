//
//  LogInViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import GoogleSignIn
import Firebase
import Combine

enum Provider: String {
    case google
    case facebook
}

protocol LogInViewModelDelegate {
    func success()
    func error(_ errorMessage: String)
}

protocol LogInViewModelRepresentable {
    var delegate: LogInViewModelDelegate? { get set }
    func googleSignIn(_ viewController: UIViewController)
}

final class LogInViewModel<R: AppRouter> {
    var router: R?
    var delegate: LogInViewModelDelegate?
    
    init() {
        
    }
}

extension LogInViewModel: LogInViewModelRepresentable {
    func googleSignIn(_ viewController: UIViewController) {
        GIDSignIn.sharedInstance.signOut()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] signInResult, error in
            if let error = error {
                delegate?.error(error.localizedDescription)
                return
            }
            
            guard let authentication = signInResult?.user,
                  let idToken = authentication.idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: authentication.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                guard let self = self,
                      let email = result?.user.email else {
                    self?.delegate?.error("Invalid credentials")
                    return
                }
                
                if let error = error {
                    self.delegate?.error(error.localizedDescription)
                } else {
                    self.delegate?.success()
                    UserDefaultsManager.shared.email = email
                    UserDefaultsManager.shared.provider = Provider.google.rawValue
                    self.router?.process(route: .showHome)
                }
            }
        }
    }
}
