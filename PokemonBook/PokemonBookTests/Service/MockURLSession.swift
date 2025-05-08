//
//  MockURLSession.swift
//  PokemonBookTests
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation
@testable import PokemonBook

final class MockURLSession: URLSessionProtocol {
  
    private let mockData: Data
    private let mockResponse: URLResponse
    
    init(data: Data, response: URLResponse) {
        self.mockData = data
        self.mockResponse = response
    }
    
    func data(for url: URLRequest) async throws -> (Data, URLResponse) {
        return (mockData, mockResponse)
    }
}
