//
//  EmployeeProfileViewController.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 20.03.2024.
//

import UIKit

class EmployeeProfileViewController: UIViewController {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameEmployeeLabel: UILabel!
    @IBOutlet weak var namePositionLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if item is not nil
        guard let item = item else {
            return
        }
        
        // Set avatar image
        if let imageURL = URL(string: item.avatarURL) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = UIImage(data: imageData)
                        self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.width / 2
                    }
                }
            }
        }
        
        // Set employee name
        let fullName = "\(item.firstName) \(item.lastName)"
        nameEmployeeLabel.text = fullName
        
        // Set position
        namePositionLabel.text = item.position
        
        // Set birthday
        if let date = formatDate(from: item.birthday) {
                    birthdayLabel.text = date
                }
        
        if let years = calculateAge(from: item.birthday) {
            yearsLabel.text = "\(years) years"
        }
        
        
        // Set phone number
        phoneLabel.text = formatPhoneNumber(item.phone)
    }
    
    
    
    @IBAction func backButton(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

// Function to format date
func formatDate(from dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" // Assuming the birthday is in this format
    
    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    return nil
}

// Function to calculate age from date of birth
func calculateAge(from dateString: String) -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" // Assuming the birthday is in this format
    
    if let dateOfBirth = dateFormatter.date(from: dateString) {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        return ageComponents.year
    }
    
    return nil
}

func formatPhoneNumber(_ phoneNumber: String) -> String {
    // Remove any non-numeric characters from the phone number
    let cleanedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    // Check if the cleaned phone number has enough digits
    guard cleanedPhoneNumber.count == 10 else {
        return phoneNumber // Return the original phone number if it doesn't have enough digits
    }
    
    // Format the phone number
    let areaCode = String(cleanedPhoneNumber.prefix(3))
    let firstPart = String(cleanedPhoneNumber.dropFirst(3).prefix(3))
    let secondPart = String(cleanedPhoneNumber.dropFirst(6).prefix(2))
    let thirdPart = String(cleanedPhoneNumber.dropFirst(8))
    
    return "+7 (\(areaCode)) \(firstPart) \(secondPart) \(thirdPart)"
}

