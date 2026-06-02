//
//  UserFavorite.swift
//  TravelBookBackend
//
//  Created by ddorsat on 18.05.2026.
//

import Fluent
import Foundation

final class UserFavorite: Model, @unchecked Sendable {
    static let schema = "user_favorites"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "cell_id")
    var cell: Cell
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() {}

    init(userID: User.IDValue,
         cellID: Cell.IDValue) {
        self.$user.id = userID
        self.$cell.id = cellID
    }
}
