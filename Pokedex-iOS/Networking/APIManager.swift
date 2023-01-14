//
//  APIManager.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine
import CodableFirebase
import Firebase

protocol HomeListStore {
    func readRegionList() -> Future<RegionResponse, Failure>
}

protocol PokedexListStore {
    func readPokedex(region: Region) -> Future<PokedexResponse, Failure>
}

protocol PokemonListStore {
    func readPokemons(pokedex: Pokedex) -> Future<PokemonResponse, Failure>
    func saveTeam(userId: String, model: Team) -> Future<Bool, Failure>
}

protocol PokemonDetailStore {
    func readPokemonDetails(pokemon: Pokemon) -> Future<PokemonDetailBase, Failure>
}

protocol TeamListStore {
    func readTeams(userId: String) -> Future<[String : Team], Failure>
}

final class APIManager {
    private var database: DatabaseReference {
        Database.database().reference()
    }
    
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
    
    static func fetchImage(imageURL: String) async throws -> UIImage {
        guard let url = URL(string: imageURL) else { throw Failure.urlConstructError }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  let image = UIImage(data: data), 200...299 ~= statusCode else { throw Failure.statusCode }
            return image
        } catch {
            throw error
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
    func saveTeam(userId: String, model: Team) -> Future<Bool, Failure> {
        return Future { [unowned self] promise in
            let teamId = database.childByAutoId().key ?? UUID().uuidString
            do {
                let data = try FirebaseEncoder().encode(model)
                Database.database().reference().child(userId).child("teams").child(teamId).setValue(data)
                promise(.success(true))
            } catch {
                promise(.failure(.APIError(error)))
            }
        }
    }
    
    func readPokemons(pokedex: Pokedex) -> Future<PokemonResponse, Failure> {
        return request(for: pokedex.url)
    }
}

extension APIManager: PokemonDetailStore {
    func readPokemonDetails(pokemon: Pokemon) -> Future<PokemonDetailBase, Failure> {
        return request(for: pokemon.url)
    }
}

extension APIManager: TeamListStore {
    func readTeams(userId: String) -> Future<[String : Team], Failure> {
        return Future { [unowned self] promise in
            database.child(userId).child("teams").observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value else { return }
                do {
                    let response = try FirebaseDecoder().decode([String: Team].self, from: value)
                    promise(.success(response))
                } catch {
                    promise(.failure(.APIError(error)))
                }
            })
        }
    }
}
