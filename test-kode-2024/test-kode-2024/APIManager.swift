import Foundation

// Custom error type conforming to Error and LocalizedError

class APIManager {
    static let shared = APIManager()

    private init() {}

    func fetchData(completion: @escaping (Result<Personal, APIError>) -> Void) {
        guard let url = URL(string: "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users") else {
            completion(.failure(APIError(code: 404, key: "Invalid URL")))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(APIError(code: 500, key: "Network Error")))
                return
            }

            guard let data = data else {
                completion(.failure(APIError(code: 500, key: "No Data")))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(Personal.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(APIError(code: 400, key: "Decoding Error")))
            }
        }.resume()
    }
}
