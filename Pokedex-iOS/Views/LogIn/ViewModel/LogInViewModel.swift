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

protocol LogInViewModelRepresentable {
    var errorSubject: PassthroughSubject<String, Error> { get }
    func googleSignIn(_ viewController: UIViewController)
}

final class LogInViewModel<R: AppRouter> {
    var router: R?
    let errorSubject = PassthroughSubject<String, Error>()
    
    init() {
        
    }
}

extension LogInViewModel: LogInViewModelRepresentable {
    func googleSignIn(_ viewController: UIViewController) {
        GIDSignIn.sharedInstance.signOut()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] signInResult, error in
            if let error = error {
                errorSubject.send(error.localizedDescription)
                return
            }
            
            guard let authentication = signInResult?.user,
                  let idToken = authentication.idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: authentication.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                guard let self = self,
                      let email = result?.user.email else {
                    self?.errorSubject.send("Invalid credentials")
                    return
                }
                
                if let error = error {
                    self.errorSubject.send(error.localizedDescription)
                } else {
                    UserDefaultsManager.shared.email = email
                    UserDefaultsManager.shared.provider = Provider.google.rawValue
                    self.router?.process(route: .showHome)
                }
            }
        }
    }
}
