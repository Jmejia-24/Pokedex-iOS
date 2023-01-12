//
//  APIManager.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

protocol HomeListStore {
    func readRegionList() -> Future<RegionResponse, Failure>
}

protocol PokedexListStore {
    func readPokedex(region: Region) -> Future<PokedexResponse, Failure>
}

protocol PokemonListStore {
    func readPokemons(pokedex: Pokedex) -> Future<PokemonResponse, Failure>
}

final class APIManager {
    
    private func request<T>(for stringURL: String) -> Future<T, Failure> where T : Codable {
        return Future { promise in
            
            guard let url = URL(string: stringURL) else {
                promise(.failure(.urlConstructError))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data, case .none = error else { promise(.failure(.urlConstructError)); return }
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(T.self, from: data)
                    promise(.success(searchResponse))
                } catch {
                    promise(.failure(.APIError(error)))
                }
            }
            task.resume()
        }
    }
}

extension APIManager: HomeListStore {
    func readRegionList() -> Future<RegionResponse, Failure> {
        let url = "https://pokeapi.co/api/v2/region"
        return request(for: url)
    }
}

extension APIManager: PokedexListStore {
    func readPokedex(region: Region) -> Future<PokedexResponse, Failure> {
        return request(for: region.url)
    }
}

extension APIManager: PokemonListStore {
    func readPokemons(pokedex: Pokedex) -> Future<PokemonResponse, Failure> {
        return request(for: pokedex.url)
    }
}

