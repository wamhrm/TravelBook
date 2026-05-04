//
//  UserModel.swift
//  TravelBook
//
//  Created by ddorsat on 04.01.2026.
//

import Foundation

struct UserModel: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String
    let dateRegistered: Date

    init(id: UUID, name: String, email: String, dateRegistered: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.dateRegistered = dateRegistered
    }

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case dateRegistered = "date_registered"
    }
}

extension UserModel {
    static let mock = UserModel(id: UUID(), name: "Дмитрий", email: "test@test.com", dateRegistered: .now)
}
