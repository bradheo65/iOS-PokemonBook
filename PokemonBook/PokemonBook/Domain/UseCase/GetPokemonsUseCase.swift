//
//  GetPokemonsUseCase.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

protocol GetPokemonsUseCase {
    func execute(from url: String) async throws -> [PokemonPreview]
}

final class GetPokemonsUseCaseImpl: GetPokemonsUseCase {
    private let pokemonRepository: PokemonRepository
    
    init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }
    
    func execute(from url: String) async throws -> [PokemonPreview] {
        /*
         1. Get Pokemon List
         2. Get Pokemon Detail Info
         3. Get Pokemon Species
         4. Get Pokemon Form
         5. Get Pokemon Image
         */
        var pokemonPreviews: [PokemonPreview] = []
        let pokemons = try await pokemonRepository.fetchPokemons(from: url)
        for pokemon in pokemons {
            let pokemonDetail = try await pokemonRepository.fetchPokemonDetail(from: pokemon.url)
            
            let form = pokemonDetail.forms?.first
            let species = pokemonDetail.species
            
            let pokemonSpecie = try await pokemonRepository.fetchPokmonSpecies(of: species!)
            let pokemonForm = try await pokemonRepository.fetchPokemonForm(from: form?.url)
            let pokemon: Pokemon = .init(
                name: pokemonSpecie.name,
                url: pokemonForm.sprites?.frontDefault
            )
            let pokemonPreview = try await pokemonRepository.fetchPokemonImage(of: pokemon)
            pokemonPreviews.append(pokemonPreview)
        }
        return pokemonPreviews
    }
}
