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

    func filterData(with searchText: String, department: String? = nil) {
        if searchText.isEmpty && department == nil {
            // If both search text and department are empty, show all items
            filteredData = personalData?.items ?? []
        } else {
            // Filter items based on the search text and optionally by department
            filteredData = personalData?.items.filter {
                $0.firstName.localizedCaseInsensitiveContains(searchText) ||
                $0.lastName.localizedCaseInsensitiveContains(searchText) ||
                ($0.department == department && department != nil)
            } ?? []
        }
    }


    func allDepartmentsSorted() -> [String] {
        guard let items = personalData?.items else {
            return []
        }
        let departments = Set(items.map { $0.department })
        return Array(departments).sorted()
    }
    
    func sortBirthday() {
        // Sort filteredData based on birthday
        filteredData.sort { (item1, item2) -> Bool in
            // Handle empty or invalid birthdays
            guard !item1.birthday.isEmpty, !item2.birthday.isEmpty else {
                // If one of the birthdays is empty, prioritize the non-empty one
                return !item1.birthday.isEmpty
            }
            
            // Convert birthday strings to Date objects
            guard let date1 = dateFormatter.date(from: item1.birthday),
                  let date2 = dateFormatter.date(from: item2.birthday) else {
                // If parsing fails, treat both as equal
                return false
            }
            
            // Compare the Date objects
            return date1 < date2
        }
        print("Sorted data alphabetically: \(filteredData)")

    }

        func sortAlphabetically() {
            // Sort filteredData alphabetically based on last name
            filteredData.sort { (item1, item2) -> Bool in
                return item1.lastName.localizedCaseInsensitiveCompare(item2.lastName) == .orderedAscending
            }
            print("Sorted data alphabetically: \(filteredData)")

        }
        
        private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
}
