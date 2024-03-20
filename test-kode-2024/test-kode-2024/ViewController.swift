//
//  ViewController.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 07.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var employeeTableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicatorHeightViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var positionFilterCollectionView: UICollectionView!
    
     @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var isLoadingData = false
    var previousContentOffset: CGFloat = 0


    var viewModel = ViewModel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            

            
            employeeTableView.delegate = self
            employeeTableView.dataSource = self
            
            searchBar.delegate = self
            
            fetchData()
            
            viewModel.filterData(with: "")

        }
        
    func fetchData() {
        // Trigger the data fetching in the ViewModel
        animateActivityIndicator(true)
        activityIndicatorHeightViewConstraint.constant = 44

        viewModel.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                // Handle the fetched data
                print("Fetched data: \(data)")
                // Reload collection view
                DispatchQueue.main.async {
                    self?.positionFilterCollectionView.reloadData()
                    // Select the "All" tab after reloading the collection view
                    if let collectionView = self?.positionFilterCollectionView {
                        self?.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
                        self?.activityIndicatorHeightViewConstraint.constant = 0

                    }
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching data: \(error)")
            }
            self?.animateActivityIndicator(false)

        }
    }


    }

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        
        guard indexPath.row < viewModel.filteredData.count else {
            // Return a default cell if index is out of bounds
            return cell
        }
        
        let employee = viewModel.filteredData[indexPath.row]
        
        let fullName = "\(employee.firstName) \(employee.lastName)"
        
        // Check if nameLabel is not nil before assigning a value
        if let nameLabel = cell.nameLabel {
            nameLabel.text = fullName
        }
        
        // Check if positionLabel is not nil before assigning a value
        if let positionLabel = cell.positionLabel {
            positionLabel.text = employee.position
        }
        
        // Check if avatarURL is not an empty string
        if !employee.avatarURL.isEmpty, let imageURL = URL(string: employee.avatarURL) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        // Check if avatarImageView is not nil before setting its image
                        if let avatarImageView = cell.avatarImageView {
                            avatarImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.filteredData.count else {
            return
        }
        
        let selectedItem = viewModel.filteredData[indexPath.row] // Use Item instead of Employee
        
        // Instantiate EmployeeProfileViewController from storyboard
        guard let employeeProfileVC = storyboard?.instantiateViewController(withIdentifier: "EmployeeProfileViewController") as? EmployeeProfileViewController else {
            return
        }
        
        // Pass data to the EmployeeProfileViewController
        employeeProfileVC.item = selectedItem // Use item instead of employee
        
        // Push the EmployeeProfileViewController onto the navigation stack
        navigationController?.pushViewController(employeeProfileVC, animated: true)
        
        // Deselect the selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }




}
    extension ViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel.filterData(with: searchText)
            employeeTableView.reloadData()
        }
    }

    extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
               return viewModel.allDepartmentsSorted().count + 1 // Add 1 for the "All" tab
           }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DepartmentCollectionViewCell", for: indexPath) as! DepartmentCollectionViewCell

            if indexPath.item == 0 {
                cell.departmentLabel.text = "All"
            } else {
                let departments = viewModel.allDepartmentsSorted()
                if indexPath.item - 1 < departments.count {
                    let department = departments[indexPath.item - 1]
                    cell.departmentLabel.text = department
                } else {
                    cell.departmentLabel.text = "Unknown Department"
                }
            }

            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if indexPath.item == 0 {
                viewModel.filterData(with: "")
            } else {
                let selectedDepartment = viewModel.allDepartmentsSorted()[indexPath.item - 1]
                viewModel.filterData(with: "", department: selectedDepartment)
            }
            employeeTableView.reloadData()
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let departments = viewModel.allDepartmentsSorted()
            guard indexPath.item < departments.count else {
                return CGSize(width: 0, height: 0)
            }
            
            let department = departments[indexPath.item]
            let size = (department as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
            return CGSize(width: size.width + 20, height: collectionView.frame.size.height)
        }
    }

extension ViewController {
    func animateActivityIndicator(_ animate: Bool) {
        DispatchQueue.main.async {
            if animate {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}



extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > scrollView.bounds.height else {
            // Do not show indicator if the content fits in the table view
            return
        }
        
        let topOffset = scrollView.contentOffset.y
        
        // Check if the table view is scrolled above its content and not already loading data
        if topOffset <= 0 && topOffset < previousContentOffset && !isLoadingData {
            // Table view scrolled above content, fetch more data and show the top activity indicator
            animateActivityIndicator(true) // Show the activity indicator
            fetchData()
        } else {
            // Hide the top activity indicator if data is not being fetched
            animateActivityIndicator(false)
        }
        
        // Update previousContentOffset
        previousContentOffset = topOffset
    }
}






