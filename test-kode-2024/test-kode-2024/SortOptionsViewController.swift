//
//  SortOptionsViewController.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 21.03.2024.
//

import UIKit

protocol SortOptionsDelegate: AnyObject {
    func didSelectSortOption(option: SortOption)
}
enum SortOption {
    case birthday
    case alphabetical
}

class SortOptionsViewController: UIViewController, UISheetPresentationControllerDelegate {

    @IBOutlet weak var sortAlphabeticallyView: UIView!
    
    @IBOutlet weak var sortBirthdayView: UIView!
    
    @IBOutlet weak var sortAlphabeticallyLabel: UILabel!
    
    @IBOutlet weak var sortBirthdayLabel: UILabel!
    
    @IBOutlet weak var sortAlphabeticallyButton: UIButton!
    
    @IBOutlet weak var sortBirthdayButton: UIButton!
    
    @IBOutlet weak var nameControlleLabel: UILabel!
    
    weak var delegate: SortOptionsDelegate?

    var viewModel = ViewModel()

    var controller: UISheetPresentationController? {
        return presentationController as? UISheetPresentationController
    }

    var isAlphabeticalSortingActive = false
        var isBirthdaySortingActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               updateButtonImage(isAlphabeticalSortingActive, for: sortAlphabeticallyButton)
               updateButtonImage(isBirthdaySortingActive, for: sortBirthdayButton)
        
        
        nameControlleLabel.text = "Sort"
        sortAlphabeticallyLabel.text = "Sort alphabetically"
        sortBirthdayLabel.text = "Sort birthdayLabel"
        
        sortBirthdayButton.setImage(UIImage(systemName: "circle.circle"), for: .normal)
        sortAlphabeticallyButton.setImage(UIImage(systemName: "circle.circle"), for: .normal)

        // Add tap gesture recognizers to the views
               let alphabeticalTapGesture = UITapGestureRecognizer(target: self, action: #selector(alphabeticalViewTapped))
               sortAlphabeticallyView.addGestureRecognizer(alphabeticalTapGesture)

               let birthdayTapGesture = UITapGestureRecognizer(target: self, action: #selector(birthdayViewTapped))
               sortBirthdayView.addGestureRecognizer(birthdayTapGesture)
        
        
        controller?.delegate = self
        controller?.selectedDetentIdentifier = .medium
        controller?.prefersGrabberVisible = true
        controller?.detents = [
            .medium(),
            .large()
        ]
        
        
    }

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        handleSortingChange()
                dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alphabeticalViewTapped() {
                isAlphabeticalSortingActive.toggle()
               updateButtonImage(isAlphabeticalSortingActive, for: sortAlphabeticallyButton)
               isBirthdaySortingActive = false
               updateButtonImage(false, for: sortBirthdayButton)
               handleSortingChange()       }

    @IBAction func birthdayViewTapped() {
                isBirthdaySortingActive.toggle()
                updateButtonImage(isBirthdaySortingActive, for: sortBirthdayButton)
                isAlphabeticalSortingActive = false
                updateButtonImage(false, for: sortAlphabeticallyButton)
                handleSortingChange()
       }

    func handleSortingChange() {
            if isAlphabeticalSortingActive {
                delegate?.didSelectSortOption(option: .alphabetical)
            } else if isBirthdaySortingActive {
                delegate?.didSelectSortOption(option: .birthday)
            }
        }
    
       func updateButtonImage(_ isActive: Bool, for button: UIButton) {
           let imageName = isActive ? "circle.circle.fill" : "circle.circle"
           button.setImage(UIImage(systemName: imageName), for: .normal)
       }
    
    
}
