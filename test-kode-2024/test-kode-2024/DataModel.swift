//
//  DataModel.swift
//  test-kode-2024
//
//  Created by Кирилл Курочкин on 07.03.2024.
//

import Foundation

struct APIError: Codable, LocalizedError {
    let code: Int
    let key: String

    // Computed property for the localized description
    var errorDescription: String? {
        return key
    }
}


struct Personal: Codable {
    let items: [Item]
}

struct Item: Codable {
    let id: String
    let avatarURL: String
    let firstName, lastName, userTag, department: String
    let position, birthday, phone: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatarUrl"
        case firstName, lastName, userTag, department, position, birthday, phone
    }
}


