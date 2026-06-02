//
//  UserDTO.swift
//  TravelBookBackend
//
//  Created by ddorsat on 14.05.2026.
//

import Vapor

struct UserDTO: Content {
    let id: UUID?
    let name: String
    let email: String
    let dateRegistered: Date

    private enum CodingKeys: String, CodingKey {
        case id, name, email
        case dateRegistered = "date_registered"
    }
}
