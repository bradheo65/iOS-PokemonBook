//
//  ViewModelType.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation
import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
