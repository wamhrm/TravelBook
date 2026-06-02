//
//  CreateCategory.swift
//  TravelBookBackend
//
//  Created by ddorsat on 06.05.2026.
//

import Fluent

struct CreateCategory: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("categories")
            .id()
            .field("title", .string, .required)
            .field("type", .string, .required)
            .field("image", .string, .required)
            .unique(on: "type")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("categories").delete()
    }
}
