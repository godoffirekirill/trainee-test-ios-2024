//
//  APIManager.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 07.03.2024.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    private init() {}

    func fetchData(completion: @escaping (Result<Personal, Error>) -> Void) {
        guard let url = URL(string: "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users") else {
            completion(.failure(Error(code: 404, key: "Invalid URL")))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(Error(code: 500, key: "Network Error")))
                return
            }

            guard let data = data else {
                completion(.failure(Error(code: 500, key: "No Data")))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(Personal.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(Error(code: 400, key: "Decoding Error")))
            }
        }.resume()
    }
}

