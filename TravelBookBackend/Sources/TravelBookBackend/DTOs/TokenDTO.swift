//
//  TokenDTO.swift
//  TravelBookBackend
//
//  Created by ddorsat on 14.05.2026.
//

import Vapor

struct TokenDTO: Content {
    let token: String
    let user: UserDTO
}
