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
}
