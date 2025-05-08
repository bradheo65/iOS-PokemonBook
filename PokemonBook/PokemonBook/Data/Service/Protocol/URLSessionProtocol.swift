//
//  URLSessionProtocol.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

protocol URLSessionProtocol {
    func data(for url: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }
