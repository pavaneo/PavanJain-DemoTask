//
//  Untitled.swift
//  PavanJain-DemoTask
//
//  Created by Pavan Kumar J on 04/12/24.
//

import UIKit

// Class - FilterButtonCell
class FilterButtonCell: UICollectionViewCell {
    
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    /// This function is responsible for setting up UI
    private func setupUI() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.isUserInteractionEnabled = false
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        button.tintColor = .white
        button.titleLabel?.numberOfLines = 0   // Allow multiple lines
        button.titleLabel?.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    /// This function responsible for configure UICollectionViewCell
    /// - Parameters:
    ///   - title: String
    ///   - isSelected: Bool
    func configure(with title: String, isSelected: Bool) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(isSelected ? .white : .black, for: .normal)
        button.backgroundColor = isSelected ? .gray : .clear
        button.isSelected = isSelected
    }
}
