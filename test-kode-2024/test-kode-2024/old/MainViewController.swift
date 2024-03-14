//
//  MainViewController.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 09.03.2024.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate {

    
    let viewModel = ViewModel()

    // UI Elements
    private let searchBar = UISearchBar()
    private let filterButton = UIButton()
    private let professionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let loadingIcon = UIActivityIndicatorView()

    // Other properties and variables
    private var items: [Item] = []  // Replace Employee with your data model

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchData()
    }

    private func setupUI() {
        // Setup search bar and filter button
        searchBar.placeholder = "Search"
        filterButton.setTitle("Filter", for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)

        mainCollectionView.register(EmployeeCell.self, forCellWithReuseIdentifier: EmployeeCell.identifier)
        professionsCollectionView.delegate = self
        mainCollectionView.delegate = self

        // Setup professions collection view
        let professionsFlowLayout = UICollectionViewFlowLayout()
        professionsFlowLayout.scrollDirection = .horizontal
        professionsCollectionView.collectionViewLayout = professionsFlowLayout
        professionsCollectionView.dataSource = self

        // Add professionsCollectionView to the view hierarchy and set constraints
        view.addSubview(searchBar)
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        view.addSubview(professionsCollectionView)
           professionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               professionsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
               professionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               professionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               professionsCollectionView.heightAnchor.constraint(equalToConstant: 44),
           ])
        view.addSubview(mainCollectionView)
           mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               mainCollectionView.topAnchor.constraint(equalTo: professionsCollectionView.bottomAnchor, constant: 20),
               mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])

        // Start loading icon animation
        loadingIcon.startAnimating()
    }


   private func fetchData() {
        // Trigger the data fetching in the ViewModel
        viewModel.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                // Handle the fetched data
                print("Fetched data: \(data)")
                // Reload UI or update any necessary components
            case .failure(let error):
                // Handle the error
                print("Error fetching data: \(error)")
            }
        }
    }

    @objc private func filterButtonTapped() {
        // Implement logic to show bottom sheet for filtering
        // Example: present a view controller or show a custom view
    }
}

// Example Employee data model (replace with your actual data model)


extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmployeeCell.identifier, for: indexPath) as? EmployeeCell else {
            return UICollectionViewCell()
        }

        if let employee = viewModel.employee(at: indexPath.row) {
            // Configure the cell with employee data
            cell.configure(with: employee)
        }

        return cell
    }
}

