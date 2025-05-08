//
//  NetworkError.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case httpError(code: Int)
    case imageConvertingError
}
