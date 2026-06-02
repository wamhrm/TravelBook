//
//  AuthDTOs.swift
//  TravelBookBackend
//
//  Created by ddorsat on 02.06.2026.
//

import Vapor

struct CreateAccountRequest: Content {
    let email: String
    let name: String
    let password: String
}

struct SignInRequest: Content {
    let email: String
    let password: String
}
