//
//  Token.swift
//  TravelBookBackend
//
//  Created by ddorsat on 12.05.2026.
//

import Fluent
import Foundation

final class Token: Model, @unchecked Sendable {
    static let schema = "tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "value")
    var value: String
    
    @Parent(key: "user_id")
    var user: User
    
    init() {}

    init(value: String,
         userID: User.IDValue) {
        self.value = value
        self.$user.id = userID
    }
}
