//
//  ViewController.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/7/25.
//

import UIKit
import Combine

final class PokemonListViewController: UIViewController {
    private let input: PassthroughSubject<PokemonListViewModel.Input, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = .init(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
    }()
    
    private enum Section: CaseIterable {
        case main
    }
    private var dataSource: UITableViewDiffableDataSource<Section, PokemonPreview>!
    private var pokemons: [PokemonPreview] = []

    private let viewModel: PokemonListViewModel

    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        setupSearchController()
        setupTableView()
        setupLayout()
        setupBinding()
        
        self.input.send(.viewDidLoad)
    }
}

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        self.input.send(.searchTextDidChange(pokemons: pokemons, name: text))
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pokemon = pokemons[indexPath.row]
        
        self.input.send(.didTapRow(data: pokemon))
    }
}

private extension PokemonListViewController {
    func setupView() {
        self.view.backgroundColor = .white
        [tableView].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.title = "Pokémon"
    }
    
    func setupTableView() {
        tableView.register(PokemonListCell.self, forCellReuseIdentifier: PokemonListCell.reuseIdentifier)
        dataSource = UITableViewDiffableDataSource<Section, PokemonPreview>(tableView: self.tableView) { tableView, indexPath, preview in
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PokemonListCell.reuseIdentifier,
                    for: indexPath
                ) as? PokemonListCell
            else {
                return UITableViewCell(frame: .zero)
            }
            cell.configure(
                with: preview.image,
                and: preview.name
            )
            return cell
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupBinding() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .didFinishPokemonPreviewFetch(let pokemonPreview):
                    self?.pokemons = pokemonPreview
                    self?.applySnapshot(with: pokemonPreview, isAmiating: false)
                case .didFinishSearch(let pokemons):
                    self?.applySnapshot(with: pokemons, isAmiating: true)
                case .showAlert(let title, let message):
                    self?.showAlert(with: title, and: message)
                }
            }
            .store(in: &cancellables)
    }
    
    func applySnapshot(with pokemonPreview: [PokemonPreview], isAmiating: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonPreview>()
        snapshot.appendSections([.main])
        snapshot.appendItems(pokemonPreview)
        
        dataSource.apply(snapshot, animatingDifferences: isAmiating)
    }
    
    func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
