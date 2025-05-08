//
//  NetworkServiceTests.swift
//  PokemonBookTests
//
//  Created by HEOGEON on 5/8/25.
//

import XCTest
@testable import PokemonBook

struct TestData: Codable {
    let id: String
    let name: String
}

final class NetworkServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchPokemons_ParsesMockResponse() async throws {
        // Given: Mock 데이터 생성
        let testData: TestData = .init(
            id: "pokemon",
            name: "bulbasaur"
        )
        let data = try JSONEncoder().encode(testData)
        let response = HTTPURLResponse(
            url: URL(string: "https://www.test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let mockSession = MockURLSession(data: data, response: response)
        let pokemonAPIService = NetworkService(session: mockSession)
        let urlRequest = URLRequest(url: URL(string: "https://www.test.com")!)
        // When
        let result = try await pokemonAPIService.request(
            TestData.self,
            urlRequest
        )
        
        // Then
        XCTAssertEqual(result.id, "pokemon")
        XCTAssertEqual(result.name, "bulbasaur")
    }
    
    func testFetchPokemons_URLResponseFail() async throws {
        // Given: Mock 데이터 생성
        let testData: TestData = .init(
            id: "pokemon",
            name: "bulbasaur"
        )
        let data = try JSONEncoder().encode(testData)
        let response = URLResponse(
            url: URL(string: "https://www.test.com")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        let mockSession = MockURLSession(data: data, response: response)
        let pokemonAPIService = NetworkService(session: mockSession)
        let urlRequest = URLRequest(url: URL(string: "https://www.test.com")!)

        // When // Then
        do {
            let _ = try await pokemonAPIService.request(
                TestData.self,
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
        let testData: TestData = .init(
            id: "pokemon",
            name: "bulbasaur"
        )
        let data = try JSONEncoder().encode(testData)
        let response = HTTPURLResponse(
            url: URL(string: "https://www.test.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        let mockSession = MockURLSession(data: data, response: response)
        let pokemonAPIService = NetworkService(session: mockSession)
        let urlRequest = URLRequest(url: URL(string: "https://www.test.com")!)

        // When // Then
        do {
            let _ = try await pokemonAPIService.request(
                TestData.self,
                urlRequest
            )
            XCTFail("Expected to throw, but succeeded.")
        } catch NetworkError.httpError(let code) {
            XCTAssertEqual(code, 404)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
