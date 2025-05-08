//
//  NetworkServiceProtocol.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ type: T.Type, _ urlRequest: URLRequest) async throws -> T
}
