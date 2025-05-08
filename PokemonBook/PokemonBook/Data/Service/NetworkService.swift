//
//  NetworkService.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/7/25.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ type: T.Type, _ urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(code: httpResponse.statusCode)
        }
        let result = try JSONDecoder().decode(T.self, from: data)
        
        return result
    }
}
