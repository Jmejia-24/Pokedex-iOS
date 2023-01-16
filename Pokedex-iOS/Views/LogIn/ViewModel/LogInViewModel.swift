//
//  LogInViewModel.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import GoogleSignIn
import Firebase
import FacebookLogin

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
    func facebookSignIn(_ viewController: UIViewController)
}

final class LogInViewModel<R: AppRouter> {
    var router: R?
    var delegate: LogInViewModelDelegate?
    
    init() {
        
    }
    
    private func successSignIn(email: String, provider: Provider) {
        self.delegate?.success()
        UserDefaultsManager.shared.provider = provider.rawValue
        self.router?.process(route: .showHome)
    }
}

extension LogInViewModel: LogInViewModelRepresentable {
    func googleSignIn(_ viewController: UIViewController) {
        GIDSignIn.sharedInstance.signOut()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] signInResult, error in
            if let _ = error {
                delegate?.error("")
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
                    self.successSignIn(email: email, provider: .google)
                }
            }
        }
    }
    
    func facebookSignIn(_ viewController: UIViewController) {
        let logInManager = LoginManager()
        logInManager.logOut()
        
        logInManager.logIn(permissions: [.email], viewController: viewController) { [unowned self] result in
            switch result {
            case .success(granted: _, declined: _, token: let token):
                guard let tokenString = token?.tokenString else { return}
                let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
                Auth.auth().signIn(with: credential) { [weak self] result, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        self.delegate?.error(error.localizedDescription)
                    } else {
                        self.successSignIn(email: "", provider: .facebook)
                    }
                }
            case .cancelled:
                delegate?.error("")
            case .failed(_):
                delegate?.error("Error when logging in with facebook")
            }
        }
    }
}
