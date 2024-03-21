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
    
    @IBOutlet weak var phoneView: UIView!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let phoneLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneLabelTapped))
        phoneView.addGestureRecognizer(phoneLabelTapGesture)
        phoneView.isUserInteractionEnabled = true
        
        
        
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
        let formattedPhoneNumber = formatPhoneNumberForDisplay(item.phone)
        phoneLabel.text = formattedPhoneNumber
        
        
        
        
        
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    @objc func phoneLabelTapped() {
        let phoneNumberForCall = formatPhoneNumberForCall(item!.phone)
        callPhoneNumber(phoneNumberForCall)
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

func formatPhoneNumberForDisplay(_ phoneNumber: String) -> String {
    let cleanedPhoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
    
    guard cleanedPhoneNumber.count == 10 else {
        return phoneNumber // Return the original phone number if it doesn't have enough digits
    }
    
    let areaCode = String(cleanedPhoneNumber.prefix(3))
    let firstPart = String(cleanedPhoneNumber.dropFirst(3).prefix(3))
    let secondPart = String(cleanedPhoneNumber.dropFirst(6).prefix(2))
    let thirdPart = String(cleanedPhoneNumber.dropFirst(8))
    
    return "+7 (\(areaCode)) \(firstPart)-\(secondPart)-\(thirdPart)"
}

func formatPhoneNumberForCall(_ phoneNumber: String) -> String {
    let cleanedPhoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
    return "+7\(cleanedPhoneNumber)"
}



func callPhoneNumber(_ cleanedPhoneNumber: String) {

    
    guard let phoneURL = URL(string: "tel://\(cleanedPhoneNumber)") else {
         print("Invalid phone number URL: tel://\(cleanedPhoneNumber)")
         return // Invalid URL
     }
     print("Calling phone number: \(phoneURL)")
     UIApplication.shared.open(phoneURL)
}

