//
//  GetPokemonFormResponse.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

struct GetPokemonFormResponse: Codable {
    let formName: String?
    let formNames: [String?]
    let formOrder, id: Int?
    let isBattleOnly, isDefault, isMega: Bool?
    let name: String?
    let names: [String?]
    let order: Int?
    let pokemon: Pokemon?
    let sprites: Sprites?
    let types: [TypeElement]?
    let versionGroup: Pokemon?
    
    enum CodingKeys: String, CodingKey {
        case formName = "form_name"
        case formNames = "form_names"
        case formOrder = "form_order"
        case id
        case isBattleOnly = "is_battle_only"
        case isDefault = "is_default"
        case isMega = "is_mega"
        case name, names, order, pokemon, sprites, types
        case versionGroup = "version_group"
    }
    
    func toEntity() -> PokemonForm {
        let pokemonForm: PokemonForm = .init(
            pokemon: pokemon,
            sprites: sprites
        )
        return pokemonForm
    }
}

// MARK: - Sprites
struct Sprites: Codable {
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int?
    let type: Pokemon?
}
