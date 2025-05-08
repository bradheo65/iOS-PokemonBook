//
//  GetPokemonResponse.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

// MARK: - GetPokemonResponse
struct GetPokemonResponse: Codable {
    let count: Int?
    let next: String?
    let results: [Pokemon]?
}


// MARK: - Pokemon
struct Pokemon: Codable {
    let name: String?
    let url: String?
}
