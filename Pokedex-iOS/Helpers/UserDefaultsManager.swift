//
//  UserDefaultsManager.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/13/23.
//

import Foundation

public enum StorageKey: String {
    case email
    case provider
}

public protocol UserDefaultsManagerProtocol: AnyObject {
    var email: String { get set }
    var provider: String { get set }
}

public final class UserDefaultsManager: UserDefaultsManagerProtocol {
    public static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    public var email: String {
        get {
            defaults.string(forKey: StorageKey.email.rawValue) ?? ""
        }
        set(value) {
            defaults.set(value, forKey: StorageKey.email.rawValue)
        }
    }
    
    public var provider: String {
        get {
            defaults.string(forKey: StorageKey.provider.rawValue) ?? ""
        }
        set(value) {
            defaults.set(value, forKey: StorageKey.provider.rawValue)
        }
    }
}
