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
    
    func fetchPokemons(from url: String) async throws -> [Pokemon] {
        let url = URL(string: url)!
        let urlRequest = URLRequest(url: url)
        let reponse = try await networkService.request(
            GetPokemonResponse.self,
            urlRequest
        )
        let result = reponse.results ?? []
        return result
    }
    
    func fetchPokemonDetail(from url: String?) async throws -> PokemonDetail {
        guard
            let url = url,
            let url = URL(string: url)
        else {
            throw NetworkError.invalidURL
        }
        let urlRequest = URLRequest(url: url)
        let response = try await networkService.request(
            GetPokemonDetailResponse.self,
            urlRequest
        )
        let result = response.toEntity()
        return result
    }
    
    func fetchPokemonForm(from url: String?) async throws -> PokemonForm {
        guard
            let url = url,
            let url = URL(string: url)
        else {
            throw NetworkError.invalidURL
        }
        let urlRequest = URLRequest(url: url)
        let response = try await networkService.request(
            GetPokemonFormResponse.self,
            urlRequest
        )
        let result = response.toEntity()
        return result
    }
    
    func fetchPokemonImage(of pokemon: Pokemon) async throws -> PokemonPreview {
        guard
            let url = pokemon.url,
            let url = URL(string: url)
        else {
            throw NetworkError.invalidURL
        }
        let urlRequest = URLRequest(url: url)
        let image = try await networkService.fetchImage(urlRequest)
        let pokemonPreview: PokemonPreview = .init(
            image: image,
            name: pokemon.name ?? ""
        )
        return pokemonPreview
    }
}
