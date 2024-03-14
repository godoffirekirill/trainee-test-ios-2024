//
//  ViewController.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 07.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var employeeTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var filterWorkItem: DispatchWorkItem?

    var isSearching: Bool {
        return ((searchBar.text?.isEmpty) == nil)
       }

    
    
    // Instantiate ViewModel
    let viewModel = ViewModel()
    
    var testArray = [1,2,3,4,5,6,7,8]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        employeeTableView.delegate = self
            employeeTableView.dataSource = self

            // Register cell class
            employeeTableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: "EmployeeCell")
        
        
        
        searchBar.delegate = self
        
        
        // Fetch data when the view loads
        fetchData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        // Check if the user tapped on the search bar
//        if range.location == 0 && text.isEmpty {
//            // Create a button
//            let filterButton = UIButton(type: .system)
//            filterButton.setTitle("Filter", for: .normal)
//            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
//            
//            // Set the button as the right view of the search bar
//            searchBar.addSubview(filterButton)
//            
//            // Adjust the frame of the button to fit within the search bar
//            filterButton.frame = CGRect(x: searchBar.frame.size.width - 70, y: 0, width: 70, height: searchBar.frame.size.height)
//        }
//        return true
//    }
//    
//    @objc func filterButtonTapped() {
//        // Handle filter button tap action
//        // Here, you can present your filter controller
//        print("Filter button tapped")
//    }
    
    
    
    
    
    
    
    
    func fetchData() {
        // Trigger the data fetching in the ViewModel
        viewModel.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                // Handle the fetched data
                print("Fetched data: \(data)")
                // Reload table view
                DispatchQueue.main.async {
                    self?.employeeTableView.reloadData()
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching data: \(error)")
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
            
            let employee = viewModel.filteredData[indexPath.row] // Use filteredData instead of employee(at:)
            
            // Combine firstName and lastName directly
            let fullName = "\(employee.firstName) \(employee.lastName)"
            cell.nameLabel.text = fullName
            
            // Assign position to the label
            cell.positionLabel.text = employee.position
            
            // Set avatar image (assuming you have a method to download or load the image)
            // You can use a library like SDWebImage to handle image loading from URLs
            if let imageURL = URL(string: employee.avatarURL) {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async {
                            cell.avatarImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            return cell
        }

    
    
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        viewModel.filterData(with: searchText)
        employeeTableView.reloadData() // Reload table view after updating filtered data
    }
}



