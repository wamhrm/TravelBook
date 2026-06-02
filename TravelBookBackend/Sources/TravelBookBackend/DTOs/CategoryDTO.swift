//
//  CategoryDTO.swift
//  TravelBookBackend
//
//  Created by ddorsat on 07.05.2026.
//

import Vapor

struct CategoryDTO: Content {
    let id: UUID?
    let title: String
    let type: String
    let image: String
    let cells: [CellDTO]
}
