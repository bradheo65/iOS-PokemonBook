//
//  PokemonRepository.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

protocol PokemonRepository {
    func fetchPokemons(url: String) async throws -> [Pokemon]
}
