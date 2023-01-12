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

protocol LogInViewModelRepresentable {
    var errorSubject: PassthroughSubject<Error, Error> { get }
    func googleSignIn(_ viewController: UIViewController)
}

final class LogInViewModel<R: AppRouter> {
    var router: R?
    let errorSubject = PassthroughSubject<Error, Error>()
    
    init() {
        
    }
}

extension LogInViewModel: LogInViewModelRepresentable {
    func googleSignIn(_ viewController: UIViewController) {
        GIDSignIn.sharedInstance.signOut()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] signInResult, error in
            if let error = error {
                errorSubject.send(error)
                return
            }
            
            guard let authentication = signInResult?.user,
                  let idToken = authentication.idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: authentication.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                guard let self = self else { return }
                if let error = error {
                    self.errorSubject.send(error)
                } else {
                    self.router?.process(route: .showHome)
                }
            }
        }
    }
}
