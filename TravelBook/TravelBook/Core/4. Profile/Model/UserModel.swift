//
//  UserModel.swift
//  TravelBook
//
//  Created by ddorsat on 04.01.2026.
//

import Foundation

struct UserModel: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let email: String
    let dateRegistered: Date

    private enum CodingKeys: String, CodingKey {
        case id, name, email
        case dateRegistered = "date_registered"
    }

    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension UserModel {
    static let mock = UserModel(id: UUID(), name: "Дмитрий", email: "test@test.com", dateRegistered: .now)
}
