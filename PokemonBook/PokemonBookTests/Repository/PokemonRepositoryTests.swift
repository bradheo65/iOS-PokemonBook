//
//  PokemonRepositoryTests.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import XCTest
@testable import PokemonBook

final class PokemonRepositoryTests: XCTestCase {
    private var session: URLSessionProtocol!
    private var networkService: NetworkServiceProtocol!
    private var pokemonRepository: PokemonRepository!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchPokemons_Success() async throws {
        let mockPokemon: Pokemon = .init(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1/"
        )
        let mockGetPokemonResponse: GetPokemonResponse = .init(
            count: 1,
            next: "https://pokeapi.co/api/v2/pokemon/?offset=10&limit=10",
            results: [mockPokemon]
        )
        let data = try JSONEncoder().encode(mockGetPokemonResponse)
        let response = HTTPURLResponse(
            url: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        self.session = MockURLSession(data: data, response: response)
        self.networkService = NetworkService(session: session)
        self.pokemonRepository = PokemonRepositoryImpl(networkService: networkService)

        let pokemon = try await pokemonRepository.fetchPokemons(from: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")
        
        XCTAssertEqual(pokemon.first?.name, mockGetPokemonResponse.results?.first?.name)
        XCTAssertEqual(pokemon.first?.url, mockGetPokemonResponse.results?.first?.url)
    }
    
    func testFetchPokemons_URLResponseFail() async throws {
        // Given: Mock 데이터 생성
        let mockPokemon: Pokemon = .init(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1/"
        )
        let mockGetPokemonResponse: GetPokemonResponse = .init(
            count: 1,
            next: "https://pokeapi.co/api/v2/pokemon/?offset=10&limit=10",
            results: [mockPokemon]
        )
        let data = try JSONEncoder().encode(mockGetPokemonResponse)
        let response = URLResponse(
            url: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil)
        self.session = MockURLSession(data: data, response: response)
        self.networkService = NetworkService(session: session)
        self.pokemonRepository = PokemonRepositoryImpl(networkService: networkService)

        // When // Then
        do {
            let _ = try await pokemonRepository.fetchPokemons(from: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")
            XCTFail("Expected to throw, but succeeded.")
        } catch NetworkError.invalidServerResponse {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchPokemons_ResponseCodeFail() async throws {
        // Given: Mock 데이터 생성
        let mockPokemon: Pokemon = .init(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1/"
        )
        let mockGetPokemonResponse: GetPokemonResponse = .init(
            count: 1,
            next: "https://pokeapi.co/api/v2/pokemon/?offset=10&limit=10",
            results: [mockPokemon]
        )
        let data = try JSONEncoder().encode(mockGetPokemonResponse)
        let response = HTTPURLResponse(
            url: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        self.session = MockURLSession(data: data, response: response)
        self.networkService = NetworkService(session: session)
        self.pokemonRepository = PokemonRepositoryImpl(networkService: networkService)

        // When // Then
        do {
            let _ = try await pokemonRepository.fetchPokemons(from: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")
            XCTFail("Expected to throw, but succeeded.")
        } catch NetworkError.httpError(let code) {
            XCTAssertEqual(code, 404)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchPokemon_Success() async throws {
        let mockGetPokemonDetailResponse: GetPokemonDetailResponse = .init(
            abilities: nil,
            baseExperience: nil,
            cries: nil,
            forms: [
                .init(
                    name: "bulbasaur",
                    url: "https://pokeapi.co/api/v2/pokemon-form/1/"
                )
            ]
        )

        let data = try JSONEncoder().encode(mockGetPokemonDetailResponse)
        let response = HTTPURLResponse(
            url: URL(string: "https://pokeapi.co/api/v2/pokemon/1")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        self.session = MockURLSession(data: data, response: response)
        self.networkService = NetworkService(session: session)
        self.pokemonRepository = PokemonRepositoryImpl(networkService: networkService)

        let pokemon = try await pokemonRepository.fetchPokemonDetail(from: "https://pokeapi.co/api/v2/pokemon/1")
        XCTAssertEqual(pokemon.forms?.first?.name, mockGetPokemonDetailResponse.forms?.first?.name)
        XCTAssertEqual(pokemon.forms?.first?.url, mockGetPokemonDetailResponse.forms?.first?.url)
    }
}
