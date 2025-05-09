//
//  PokemonListViewModel.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import Foundation
import Combine
import UIKit

final class PokemonListViewModel: ViewModelType {
    enum Input {
        case viewDidLoad
        case didTapRow(data: PokemonPreview)
    }
    
    enum Output {
        case didFinishPokemonPreviewFetch([PokemonPreview])
        case showAlert(title: String, message: String)
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellable: Set<AnyCancellable> = []
    
    private let getPokemonsUseCase: GetPokemonsUseCase
    
    init(getPokemonsUseCase: GetPokemonsUseCase) {
        self.getPokemonsUseCase = getPokemonsUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                switch event {
                case .viewDidLoad:
                    self?.fetchPokemons()
                case .didTapRow(let data):
                    self?.output.send(
                        .showAlert(
                            title: data.name,
                            message: data.name
                        )
                    )
                }
            }
            .store(in: &cancellable)
        return output.eraseToAnyPublisher()
    }
}

private extension PokemonListViewModel {
    func fetchPokemons() {
        Task {
            do {
                let pokemons = try await getPokemonsUseCase.execute(from: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20")
                self.output.send(.didFinishPokemonPreviewFetch(pokemons))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
