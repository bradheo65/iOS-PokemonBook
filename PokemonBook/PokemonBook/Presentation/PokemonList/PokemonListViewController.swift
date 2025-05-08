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
        
        return tableView
    }()
    
    private enum Section: CaseIterable {
        case main
    }
    private var dataSource: UITableViewDiffableDataSource<Section, PokemonPreview>!

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
        setupTableView()
        setupLayout()
        setupBinding()
        
        self.input.send(.viewDidLoad)
    }
}

private extension PokemonListViewController {
    func setupView() {
        self.view.backgroundColor = .white
        [tableView].forEach { view in
            self.view.addSubview(view)
        }
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
                    self?.applySnapshot(with: pokemonPreview)
                }
            }
            .store(in: &cancellables)
    }
    
    func applySnapshot(with pokemonPreview: [PokemonPreview]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonPreview>()
        snapshot.appendSections([.main])
        snapshot.appendItems(pokemonPreview)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
