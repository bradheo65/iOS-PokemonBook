//
//  PokemonRepository.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

protocol PokemonRepository {
    func fetchPokemons(from url: String) async throws -> [Pokemon]
    func fetchPokemonDetail(from url: String?) async throws -> PokemonDetail
    func fetchPokemonForm(from url: String?) async throws -> PokemonForm
    func fetchPokemonImage(of pokemon: Pokemon) async throws -> PokemonPreview
}
