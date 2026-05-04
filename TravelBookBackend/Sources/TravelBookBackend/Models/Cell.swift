//
//  File.swift
//  TravelBookServer
//
//  Created by ddorsat on 05.01.2026.
//

import Vapor
import Fluent

final class Cell: Model, Content, @unchecked Sendable  {
    static let schema = "cells"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "subtitle")
    var subtitle: String

    @Field(key: "description")
    var description: String

    @Parent(key: "category_id")
    var category: Category

    @Field(key: "date")
    var date: Date

    @Field(key: "reading_time")
    var readingTime: Int

    @Field(key: "image")
    var image: String

    @Field(key: "images")
    var images: [String]

    @Field(key: "is_popular")
    var isPopular: Bool

    @Field(key: "is_head_cell")
    var isHeadCell: Bool

    @Siblings(through: UserFavorite.self, from: \.$cell, to: \.$user)
    var favoritedBy: [User]

    init() {}

    init(id: UUID? = nil,
         title: String,
         subtitle: String,
         description: String,
         categoryID: Category.IDValue,
         date: Date,
         readingTime: Int,
         image: String,
         images: [String],
         isPopular: Bool = false,
         isHeadCell: Bool = false) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.$category.id = categoryID
        self.date = date
        self.readingTime = readingTime
        self.image = image
        self.images = images
        self.isPopular = isPopular
        self.isHeadCell = isHeadCell
    }
}
