//
//  PokemonRepositoryImpl.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

final class PokemonRepositoryImpl: PokemonRepository {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPokemons(url: String) async throws -> [Pokemon] {
        let url = URL(string: url)!
        let urlRequest = URLRequest(url: url)
        let reponse = try await networkService.request(
            GetPokemonResponse.self,
            urlRequest
        )
        let result = reponse.results ?? []
        return result
    }
}
