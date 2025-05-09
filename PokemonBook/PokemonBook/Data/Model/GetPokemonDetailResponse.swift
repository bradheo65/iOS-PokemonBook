//
//  GetPokemonDetailResponse.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

struct GetPokemonDetailResponse: Codable {
    let abilities: [Ability]?
    let baseExperience: Int?
    let cries: Cries?
    let forms: [Form]?
    let species: Pokemon?

    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case cries, forms, species
    }
    
    func toEntity() -> PokemonDetail {
        let pokmonDetail: PokemonDetail = .init(
            forms: forms,
            species: species
        )
        return pokmonDetail
    }
}

// MARK: - Ability
struct Ability: Codable {
    let ability: Form?
    let isHidden: Bool?
    let slot: Int?

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - Form
struct Form: Codable {
    let name: String?
    let url: String?
}

// MARK: - Cries
struct Cries: Codable {
    let latest, legacy: String?
}
