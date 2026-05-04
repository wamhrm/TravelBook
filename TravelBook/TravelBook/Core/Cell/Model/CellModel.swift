//
//  CellDetailsModel.swift
//  TravelBook
//
//  Created by ddorsat on 02.01.2026.
//

import Foundation

struct CellModel: Identifiable, Hashable, Codable {
    let id: UUID?
    let title: String
    let subtitle: String
    let description: String
    let category: Categories
    let date: Date
    let readingTime: Int
    let image: String
    let images: [String]
    let isPopular: Bool
    let isHeadCell: Bool
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, description, category, date, image, images
        case readingTime = "reading_time"
        case isPopular = "is_popular"
        case isHeadCell = "is_head_cell"
    }
}

extension CellModel {
    static let mock = CellModel(id: UUID(), title: "Как выбрать чемодан", subtitle: "Гид по комфортным путешествиям", description: "Правильный чемодан — это инвестиция в спокойствие во время поездки. Мы разберем ключевые критерии выбора: что лучше — пластик или ткань, сколько должно быть колес для маневренности и как подобрать идеальный размер под требования авиакомпаний, чтобы ваш багаж всегда долетал в целости и сохранности.", category: .abroad, date: .now, readingTime: 5, image: "", images: ["test", "test", "test"], isPopular: true, isHeadCell: true)
    
    static let mockArray = [
        CellModel(id: UUID(), title: "Как выбрать чемодан", subtitle: "Гид по комфортным путешествиям", description: "Правильный чемодан — это инвестиция в спокойствие во время поездки. Мы разберем ключевые критерии выбора: что лучше — пластик или ткань, сколько должно быть колес для маневренности и как подобрать идеальный размер под требования авиакомпаний, чтобы ваш багаж всегда долетал в целости и сохранности.", category: .abroad, date: .now, readingTime: 5, image: "", images: ["test", "test", "test"], isPopular: true, isHeadCell: true),
        CellModel(id: UUID(), title: "Как выбрать чемодан", subtitle: "Гид по комфортным путешествиям", description: "Правильный чемодан — это инвестиция в спокойствие во время поездки. Мы разберем ключевые критерии выбора: что лучше — пластик или ткань, сколько должно быть колес для маневренности и как подобрать идеальный размер под требования авиакомпаний, чтобы ваш багаж всегда долетал в целости и сохранности.", category: .abroad, date: .now, readingTime: 5, image: "", images: ["test", "test", "test"], isPopular: true, isHeadCell: true),
        CellModel(id: UUID(), title: "Как выбрать чемодан", subtitle: "Гид по комфортным путешествиям", description: "Правильный чемодан — это инвестиция в спокойствие во время поездки. Мы разберем ключевые критерии выбора: что лучше — пластик или ткань, сколько должно быть колес для маневренности и как подобрать идеальный размер под требования авиакомпаний, чтобы ваш багаж всегда долетал в целости и сохранности.", category: .abroad, date: .now, readingTime: 5, image: "", images: ["test", "test", "test"], isPopular: true, isHeadCell: true),
        CellModel(id: UUID(), title: "Как выбрать чемодан", subtitle: "Гид по комфортным путешествиям", description: "Правильный чемодан — это инвестиция в спокойствие во время поездки. Мы разберем ключевые критерии выбора: что лучше — пластик или ткань, сколько должно быть колес для маневренности и как подобрать идеальный размер под требования авиакомпаний, чтобы ваш багаж всегда долетал в целости и сохранности.", category: .abroad, date: .now, readingTime: 5, image: "", images: ["test", "test", "test"], isPopular: true, isHeadCell: true),
        CellModel(id: UUID(), title: "Как выбрать чемодан", subtitle: "Гид по комфортным путешествиям", description: "Правильный чемодан — это инвестиция в спокойствие во время поездки. Мы разберем ключевые критерии выбора: что лучше — пластик или ткань, сколько должно быть колес для маневренности и как подобрать идеальный размер под требования авиакомпаний, чтобы ваш багаж всегда долетал в целости и сохранности.", category: .abroad, date: .now, readingTime: 5, image: "", images: ["test", "test", "test"], isPopular: true, isHeadCell: true),
        CellModel(id: UUID(), title: "Как выбрать чемодан", subtitle: "Гид по комфортным путешествиям", description: "Правильный чемодан — это инвестиция в спокойствие во время поездки. Мы разберем ключевые критерии выбора: что лучше — пластик или ткань, сколько должно быть колес для маневренности и как подобрать идеальный размер под требования авиакомпаний, чтобы ваш багаж всегда долетал в целости и сохранности.", category: .abroad, date: .now, readingTime: 5, image: "", images: ["test", "test", "test"], isPopular: true, isHeadCell: true)]
}
