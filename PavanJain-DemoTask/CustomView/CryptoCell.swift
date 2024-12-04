//
//  CryptoCell.swift
//  Pavanjain-Task
//
//  Created by Pavan Kumar J on 02/12/24.
//
import UIKit

// Class - CryptoCell
class CryptoCell: UITableViewCell {
    static let identifier = "CryptoCell"
    
    /// coin Image view
    private let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// New Badge Image view
    private let newBadgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "new2")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Subtitle label
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This function is responsible for setting up  UI for UITableview cell
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(coinImageView)
        contentView.addSubview(newBadgeImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: coinImageView.leadingAnchor, constant: -16),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: coinImageView.leadingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            coinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coinImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 40),
            coinImageView.heightAnchor.constraint(equalToConstant: 40),
            
            newBadgeImageView.topAnchor.constraint(equalTo: coinImageView.topAnchor),
            newBadgeImageView.trailingAnchor.constraint(equalTo: coinImageView.trailingAnchor),
            newBadgeImageView.widthAnchor.constraint(equalToConstant: 25),
            newBadgeImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    /// This function is responsible for configure the tableview cell based on the data provided
    /// - Parameter coin: CryptoCoin
    func configure(with coin: CryptoCoin) {
        titleLabel.text = coin.name
        subtitleLabel.text = coin.symbol
        
        // Enable/disable interaction based on active status
        isUserInteractionEnabled = coin.isActive
        titleLabel.textColor = coin.isActive ? .label : .gray
        subtitleLabel.textColor = coin.isActive ? .secondaryLabel : .gray
        
        // Set the appropriate coin image based on the type and status
        if coin.type == "coin" && coin.isActive {
            coinImageView.image = UIImage(named: "active")
        } else if coin.type == "token" && coin.isActive {
            coinImageView.image = UIImage(named: "token")
        } else if !coin.isActive {
            coinImageView.image = UIImage(named: "inactive")
        }
        
        newBadgeImageView.isHidden = !coin.isNew
    }
}
