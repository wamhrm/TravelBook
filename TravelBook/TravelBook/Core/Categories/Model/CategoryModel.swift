//
//  CategoriesModel.swift
//  TravelBook
//
//  Created by ddorsat on 02.01.2026.
//

import Foundation
import SwiftUI

struct CategoryModel: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let type: Categories
    let image: String
    let cells: [CellModel]

    init(id: UUID, title: String, type: Categories, image: String, cells: [CellModel] = []) {
        self.id = id
        self.title = title
        self.type = type
        self.image = image
        self.cells = cells
    }

    enum CodingKeys: String, CodingKey {
        case id, title, type, image, cells
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decode(Categories.self, forKey: .type)
        self.image = try container.decode(String.self, forKey: .image)
        self.cells = try container.decodeIfPresent([CellModel].self, forKey: .cells) ?? []
    }
}

enum Categories: String, Codable, CaseIterable {
    case abroad, fraud, leisure, food, tickets, packing, culture, health, family, budget
        
    var title: String {
        switch self {
            case .abroad: return "Заграница"
            case .fraud: return "Безопасность"
            case .leisure: return "Развлечения"
            case .food: return "Еда"
            case .tickets: return "Билеты"
            case .packing: return "Багаж"
            case .culture: return "Культура"
            case .health: return "Здоровье"
            case .family: return "С детьми"
            case .budget: return "Экономия"
        }
    }
    
    var color: Color {
        switch self {
            case .abroad: return .orange
            case .fraud: return .red
            case .leisure: return .purple
            case .food: return .green
            case .tickets: return .blue
            case .packing: return .brown
            case .culture: return .indigo
            case .health: return .mint
            case .family: return .yellow
            case .budget: return .teal
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
