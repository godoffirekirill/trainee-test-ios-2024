//
//  ViewModel.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 07.03.2024.
//

import Foundation

class ViewModel {
    var personalData: Personal?

    var filteredData: [Item] = []
    
    
    
    func fetchData(completion: @escaping (Result<Personal, Error>) -> Void) {
        APIManager.shared.fetchData { [weak self] result in
            switch result {
            case .success(let personalData):
                self?.personalData = personalData
                self?.filterData(with: "") // Filter with empty search text to display all data
                completion(.success(personalData))
            case .failure(let error):
                print("API Error: \(error)")
                completion(.failure(error))
            }
        }
    }

    
    
    
    func numberOfItems() -> Int {
        return personalData?.items.count ?? 0
    }

    func employee(at index: Int) -> Item? {
        guard let items = personalData?.items, index >= 0, index < items.count else {
            return nil
        }
        return items[index]
    }
    
    
    func allProfessions() -> [String] {
         guard let items = personalData?.items else {
             return []
         }

         let professions = Set(items.map { $0.position })
         return Array(professions)
     }
}

extension ViewModel {
    func filterData(with searchText: String) {
        if searchText.isEmpty {
            // If search text is empty, show all items
            filteredData = personalData?.items ?? []
        } else {
            // Filter items based on the search text
            filteredData = personalData?.items.filter { $0.firstName.localizedCaseInsensitiveContains(searchText) || $0.lastName.localizedCaseInsensitiveContains(searchText) } ?? []
        }
    }
}





