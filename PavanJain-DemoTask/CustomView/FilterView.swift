//
//  FilterView.swift
//  Pavanjain-Task
//
//  Created by Pavan Kumar J on 02/12/24.
//

import UIKit

/// FilterViewDelegate
protocol FilterViewDelegate: AnyObject {
    func didUpdateFilters(selectedFilters: [String])
}

// Class - FilterView
class FilterView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: FilterViewDelegate?
    
    private var filters = ["Active Coins", "Inactive Coins", "Only Tokens", "Only Coins", "New Coins"]
    private var selectedFilters: Set<String> = []
    
    private var collectionView: UICollectionView!
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    /// This function is responsible for updating collection view Constraint
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        // Initialize collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.register(FilterButtonCell.self, forCellWithReuseIdentifier: "FilterButtonCell")
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        updateCollectionViewHeight()
    }
    
    /// This function is responsible for updating collection view height based on the content
    func updateCollectionViewHeight() {
        let collectionViewWidth = collectionView.bounds.width - 32
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellHeight: CGFloat = 40
        var totalHeight: CGFloat = 0
        var currentRowWidth: CGFloat = 0

        for filter in filters {
            let textWidth = (filter as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 15)]).width
            let cellWidth = textWidth + 40

            if currentRowWidth + cellWidth + layout.minimumInteritemSpacing > collectionViewWidth {
                totalHeight += cellHeight + layout.minimumLineSpacing
                currentRowWidth = cellWidth
            } else {
                currentRowWidth += cellWidth + layout.minimumInteritemSpacing
            }
        }

        totalHeight += cellHeight

        if let heightConstraint = collectionView.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = totalHeight
        } else {
            collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: (totalHeight / CGFloat(self.filters.count)) * 2)
            collectionViewHeightConstraint?.isActive = true
        }
    }

    
    // UICollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterButtonCell", for: indexPath) as! FilterButtonCell
        let filter = filters[indexPath.item]
        let isSelected = selectedFilters.contains(filter)
        cell.configure(with: filter, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filters[indexPath.item]
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
        } else {
            selectedFilters.insert(filter)
        }
        delegate?.didUpdateFilters(selectedFilters: Array(selectedFilters))
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filter = filters[indexPath.item]
        let tempCell = FilterButtonCell()
        tempCell.configure(with: filter, isSelected: selectedFilters.contains(filter))
        return CGSize(width: 80, height: 40)
    }
}
