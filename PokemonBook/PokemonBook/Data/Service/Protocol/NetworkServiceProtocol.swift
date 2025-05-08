//
//  NetworkServiceProtocol.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ type: T.Type, _ urlRequest: URLRequest) async throws -> T
    func fetchImage(_ urlRequest: URLRequest) async throws -> UIImage
}
