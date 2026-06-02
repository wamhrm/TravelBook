//
//  Category.swift
//  TravelBookBackend
//
//  Created by ddorsat on 05.05.2026.
//

import Fluent
import Foundation

final class Category: Model, @unchecked Sendable {
    static let schema = "categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "type")
    var type: String

    @Field(key: "image")
    var image: String

    @Children(for: \.$category)
    var cells: [Cell]

    init() {}

    init(title: String,
         type: String,
         image: String) {
        self.title = title
        self.type = type
        self.image = image
    }
}

extension Category {
    func toDTO() -> CategoryDTO {
        CategoryDTO(id: id,
                    title: title,
                    type: type,
                    image: image,
                    cells: cells.map { $0.toDTO() })
    }
}
