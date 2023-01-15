//
//  Spinner.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/15/23.
//

import UIKit

protocol Spinner: AnyObject {
    func showSpinner()
    func hideSpinner()
}

extension Spinner where Self : UIViewController {
    
    private func setSpinner() {
        let containerView = UIView()
        containerView.tag = tag
        containerView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: parentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
        ])
        
        containerView.backgroundColor = .black.withAlphaComponent(opacity)
        addSpinner(containerView: containerView)
    }
    
    private func addSpinner(containerView: UIView) {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        spinner.startAnimating()
    }
    
    func showSpinner() {
        guard notAnotherSpinner else { return }
        setSpinner()
    }
    
    func hideSpinner(){
        if let foundView = parentView.viewWithTag(tag) {
            foundView.removeFromSuperview()
        }
    }
    
    private var notAnotherSpinner: Bool {
        parentView.viewWithTag(tag) == nil
    }
    
    private var parentView: UIView {
        navigationController?.view ?? view
    }
    
    private var tag: Int {
        100
    }
    
    private var opacity: CGFloat {
        0.3
    }
}
