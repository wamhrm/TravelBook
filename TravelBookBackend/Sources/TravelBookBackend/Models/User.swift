//
//  File.swift
//  TravelBookServer
//
//  Created by ddorsat on 06.01.2026.
//

import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable, Authenticatable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Field(key: "date_registered")
    var dateRegistered: Date

    @Siblings(through: UserFavorite.self, from: \.$user, to: \.$cell)
    var favorites: [Cell]

    init() {}

    init(id: UUID? = nil,
         email: String,
         name: String,
         dateRegistered: Date = .now,
         passwordHash: String) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
        self.dateRegistered = dateRegistered
    }
}
