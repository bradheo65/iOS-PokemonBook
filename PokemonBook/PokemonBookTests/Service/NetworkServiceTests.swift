//
//  NetworkServiceTests.swift
//  PokemonBookTests
//
//  Created by HEOGEON on 5/8/25.
//

import XCTest
@testable import PokemonBook

final class NetworkServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchPokemons_ParsesMockResponse() async throws {
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
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let mockSession = MockURLSession(data: data, response: response)
        let pokemonAPIService = NetworkService(session: mockSession)
        let urlRequest = URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")!)
        // When
        let result = try await pokemonAPIService.request(
            GetPokemonResponse.self,
            urlRequest
        )
        
        // Then
        XCTAssertEqual(result.results?.count, 1)
        XCTAssertEqual(result.results?.first?.name, "bulbasaur")
        XCTAssertEqual(result.results?.first?.url, "https://pokeapi.co/api/v2/pokemon/1/")
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
        let mockSession = MockURLSession(data: data, response: response)
        let pokemonAPIService = NetworkService(session: mockSession)
        let urlRequest = URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")!)

        // When // Then
        do {
            let _ = try await pokemonAPIService.request(
                GetPokemonResponse.self,
                urlRequest
            )
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
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )!
        let mockSession = MockURLSession(data: data, response: response)
        let pokemonAPIService = NetworkService(session: mockSession)
        let urlRequest = URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=10")!)

        // When // Then
        do {
            let _ = try await pokemonAPIService.request(
                GetPokemonResponse.self,
                urlRequest
            )
            XCTFail("Expected to throw, but succeeded.")
        } catch NetworkError.httpError(let code) {
            XCTAssertEqual(code, 400)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
