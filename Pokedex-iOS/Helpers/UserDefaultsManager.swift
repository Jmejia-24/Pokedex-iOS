//
//  UserDefaultsManager.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/13/23.
//

import Foundation

public enum StorageKey: String {
    case provider
}

public protocol UserDefaultsManagerProtocol: AnyObject {
    var provider: String { get set }
}

public final class UserDefaultsManager: UserDefaultsManagerProtocol {
    public static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    public var provider: String {
        get {
            defaults.string(forKey: StorageKey.provider.rawValue) ?? ""
        }
        set(value) {
            defaults.set(value, forKey: StorageKey.provider.rawValue)
        }
    }
}
