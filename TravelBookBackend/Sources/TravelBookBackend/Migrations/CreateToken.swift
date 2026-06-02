//
//  CreateToken.swift
//  TravelBookBackend
//
//  Created by ddorsat on 13.05.2026.
//

import Fluent

struct CreateToken: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("tokens")
            .id()
            .field("value", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("tokens").delete()
    }
}
