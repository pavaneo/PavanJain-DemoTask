//
//  CryptoListViewController.swift
//  Pavanjain-Task
//
//  Created by Pavan Kumar J on 02/12/24.
//

import UIKit
import Combine

/// Class - CryptoListViewController
class CryptoListViewController: UIViewController {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let filterView = FilterView()
    private let activityIndicator: UIActivityIndicatorView = .init()
    private let errorMessageLabel: UILabel = .init()
    
    // Instace of viewModel
    private var viewModel = CoinViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicatorToView(activityIndicator: activityIndicator, view: tableView)
        setupUI()
        setupSearchController()
        setupErrorMessageLabel()
        setupBindings()
        viewModel.fetchCoins() 
    }
    
    // Setup the error message label
    private func setupErrorMessageLabel() {
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = .black
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.isHidden = true
        view.addSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
            errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            errorMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addActivityIndicatorToView(activityIndicator: UIActivityIndicatorView, view: UIView){
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: activityIndicator,
                                              attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: activityIndicator,
                                              attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
        activityIndicator.startAnimating()
    }
    
    /// This function is responsible for setting up search controller
    private func setupSearchController() {
        // Set the search results updater
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Customize the search bar background color
        searchController.searchBar.barTintColor = UIColor(red: 86.0/255.0, green: 12.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = .white
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.textColor = .black
        }
    }
    
    /// This function is responsible for setting up new UI
    private func setupUI() {
        title = "COIN"
        view.backgroundColor = .white
        
        // TableView
        tableView.register(CryptoCell.self, forCellReuseIdentifier: CryptoCell.identifier)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coins"
        navigationItem.searchController = searchController
        
        // Filter View
        filterView.delegate = self
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        
        // Layout
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: filterView.topAnchor)
        ])
    }
    
    /// This function is responsbile for setting up binding from the view model
    private func setupBindings() {
        viewModel.$filteredCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.errorMessageLabel.text = error.description
                    self?.errorMessageLabel.isHidden = false
                } else {
                    self?.errorMessageLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
}

// Tableview - Delegate Methods

extension CryptoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCell.identifier, for: indexPath) as? CryptoCell else {
            return UITableViewCell()
        }
        let coin = viewModel.filteredCoins[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: coin)
        return cell
    }
}

// Extension of CryptoListViewController to conform UISearchResultsUpdating

extension CryptoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        viewModel.search(query: query)
    }
}

// Extension of CryptoListViewController to conform FilterViewDelegate

extension CryptoListViewController: FilterViewDelegate {
    func didUpdateFilters(selectedFilters: [String]) {
        viewModel.apply(conditions: selectedFilters)
    }
}

