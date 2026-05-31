//
//  CategoriesModel.swift
//  TravelBook
//
//  Created by ddorsat on 02.01.2026.
//

import Foundation
import SwiftUI

struct CategoryModel: Identifiable, Hashable, Codable, Mockable {
    let id: UUID
    let title: String
    let type: Categories
    let image: String
    let cells: [CellModel]

    init(id: UUID,
         title: String,
         type: Categories,
         image: String,
         cells: [CellModel] = []) {
        self.id = id
        self.title = title
        self.type = type
        self.image = image
        self.cells = cells
    }
}

enum Categories: String, Codable, CaseIterable {
    case abroad, fraud, leisure, food, tickets, packing, culture, health, family, budget

    var title: String {
        switch self {
            case .abroad: "Заграница"
            case .fraud: "Безопасность"
            case .leisure: "Развлечения"
            case .food: "Еда"
            case .tickets: "Билеты"
            case .packing: "Багаж"
            case .culture: "Культура"
            case .health: "Здоровье"
            case .family: "С детьми"
            case .budget: "Экономия"
        }
    }

    var color: Color {
        switch self {
            case .abroad: .orange
            case .fraud: .red
            case .leisure: .purple
            case .food: .green
            case .tickets: .blue
            case .packing: .brown
            case .culture: .indigo
            case .health: .mint
            case .family: .yellow
            case .budget: .teal
        }
    }
}

extension CategoryModel {
    static let mock = CategoryModel(id: UUID(), title: "Как не стать жертвой обмана", type: .fraud, image: "")
    
    static let mockArray: [CategoryModel] = [
        CategoryModel(id: UUID(), title: "Главный чек-лист перед выездом", type: .abroad, image: ""),
        CategoryModel(id: UUID(), title: "Как не стать жертвой обмана", type: .fraud, image: ""),
        CategoryModel(id: UUID(), title: "ТОП-10 развлечений для активного отдыха", type: .leisure, image: ""),
        CategoryModel(id: UUID(), title: "Гастрономический туризм: что пробовать", type: .food, image: ""),
        CategoryModel(id: UUID(), title: "Ловим дешевые авиабилеты", type: .tickets, image: ""),
        CategoryModel(id: UUID(), title: "Как собрать чемодан за 15 минут", type: .packing, image: ""),
        CategoryModel(id: UUID(), title: "Языковой барьер и местные традиции", type: .culture, image: ""),
        CategoryModel(id: UUID(), title: "Что должно быть в аптечке туриста", type: .health, image: ""),
        CategoryModel(id: UUID(), title: "Путешествия с маленькими детьми", type: .family, image: ""),
        CategoryModel(id: UUID(), title: "Как сэкономить 30% бюджета поездки", type: .budget, image: "")]
}
