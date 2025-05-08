//
//  PokemonListCell.swift
//  PokemonBook
//
//  Created by HEOGEON on 5/8/25.
//

import UIKit

final class PokemonListCell: UITableViewCell {
    static let reuseIdentifier = "PokemonListCell"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumnailImage, nameLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var thumnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage, and name: String) {
        self.thumnailImage.image = image
        self.nameLabel.text = name
    }
}

private extension PokemonListCell {
    func setupView() {
        [stackView].forEach { view in
            self.contentView.addSubview(view)
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            thumnailImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3),
            thumnailImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.thumnailImage.trailingAnchor),
        ])
    }
}
